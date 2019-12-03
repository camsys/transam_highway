class Roadbed < ApplicationRecord
  include TransamObjectKey
  
  belongs_to :roadway
  has_many :roadbed_lines, dependent: :destroy

  validates :name, presence: true
  # validates :direction, presence: true
  validates :number_of_lines, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :roadway, presence: true

  def self.allowable_params
    [
      :name,
      :roadway_id,
      :direction,
      :number_of_lines
    ]
  end

  def self.create_lines(roadbed, inspection)
    return unless roadbed

    roadbed.transaction do 
      (['L', 'R'] + (1..roadbed.number_of_lines).to_a).each do |line_number|
        roadbed.roadbed_lines.create(number: line_number, inspection: inspection)
      end
    end
  end

  def asset_type
    roadway.highway_structure.asset_type
  end
  def use_minimum_clearance?
    (AncillaryStructure.subclasses.map(&:to_s) << "MiscStructure").include? asset_type.class_name
  end

  def left_edge
    roadbed_lines.where(number: ['L']).first
  end

  def right_edge
    roadbed_lines.where(number: ['R']).first
  end

  # Minimum clearance over whole roadbed for give inspection
  def minimum(inspection)
    list = []
    roadbed_lines.by_inspection(inspection).each do |l|
      if use_minimum_clearance?
        list << l.minimum_clearance unless l.minimum_clearance.nil? || l.minimum_clearance.zero?
      else
        list << l.entry unless l.entry.nil? || l.entry.zero?
        list << l.exit unless l.exit.nil? || l.exit.zero?
      end
    end
    list.min
  end

  # Maximum of the minimum clearance for each lane not counting shoulders
  # for give inspection
  def maximum(inspection)
    # Assume at least one lane
    max = 0
    get_lane_minimums(inspection).each do |min|
      # nil == no restriction automatically max
      return nil if min.nil?
      max = min if min > max
    end
    max
  end

  private 

  # min of minimum clearances, form pairs, min of each pair
  def get_lane_minimums(inspection)
    if use_minimum_clearance?
      line_mins = roadbed_lines.by_inspection(inspection).lines.pluck(:minimum_clearance).map{|x| x.try(:zero?) ? nil : x}
    else
      line_mins =
          roadbed_lines.by_inspection(inspection).lines.pluck(:entry, :exit).map do |l|
            l.reject{|v| v.nil? || v.zero?}.min
          end
    end
    lane_pairs = line_mins.reduce([]) do |p, i|
      if p.size == 0
        p << [i]
      elsif p.last.size == 1
        p.last << i
      else
        p << [p[-1][1], i]
      end
      p
    end
    lane_pairs.map{|p| p.compact.min}
  end

  def get_adjacent_line_minimums
    @adjacent_line_minimums if defined? @adjacent_line_minimums

    if use_minimum_clearance?
      line_mins = roadbed_lines.pluck(:number, :minimum_clearance).map{|x| x[1].try(:zero?) ? [x[0], nil] : x}
    else
      line_nums = roadbed_lines.pluck(:number, :entry, :exit)
      # get the min of [entry, exit] in each line, exclude nil or 0
      line_mins = line_nums.map{|l| [l[0], [l[1], l[2]].reject{|r| r.nil? || r == 0}.min]}
    end
    # sort lines in order of L, 1..., R
    sorted_line_mins = line_mins.sort_by{|l| 
      if l[0] == 'L'
        '0'
      elsif l[0] != 'R'
        l[0]
      else
        "1000" # crazy big number
      end
    }.map{|l| l[1]}
    
    adjacent_line_minimums = []
    idx = 0
    while idx < sorted_line_mins.size-1
      adjacent_line_minimums << [sorted_line_mins[idx], sorted_line_mins[idx + 1]].reject{|r| r.nil? || r == 0}.min
      if idx + 2 < sorted_line_mins.size
        adjacent_line_minimums << [sorted_line_mins[idx+1], sorted_line_mins[idx + 2]].reject{|r| r.nil? || r == 0}.min
      end

      idx += 2
    end

    @adjacent_line_minimums = adjacent_line_minimums
  end
end
