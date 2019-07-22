class Roadbed < ApplicationRecord
  include TransamObjectKey
  
  belongs_to :roadway
  has_many :roadbed_lines, dependent: :destroy

  validates :name, presence: true
  validates :direction, presence: true
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

  def left_edge
    roadbed_lines.where(number: ['L']).first
  end

  def right_edge
    roadbed_lines.where(number: ['R']).first
  end

  def minimum
    (get_adjacent_line_minimums || []).reject{|r| r.nil? || r == 0}.min
  end

  def maximum
    (get_adjacent_line_minimums || []).reject{|r| r.nil? || r == 0}.max

    [
      roadbed_lines.where.not(entry: [nil, 0]).maximum(:entry),
      roadbed_lines.where.not(exit: [nil, 0]).maximum(:exit)
      ].reject{|r| r.nil? || r == 0}.max
  end

  private 

  def get_adjacent_line_minimums
    @adjacent_line_minimums if defined? @adjacent_line_minimums

    line_nums = roadbed_lines.pluck(:number, :entry, :exit)
    # get the min of [entry, exit] in each line, exclude nil or 0
    line_mins = line_nums.map{|l| [l[0], [l[1], l[2]].reject{|r| r.nil? || r == 0}.min]}
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
