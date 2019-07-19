class Roadbed < ApplicationRecord
  include TransamObjectKey
  
  belongs_to :roadway
  has_many :roadbed_lines

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
    [
      roadbed_lines.where.not(entry: [nil, 0]).minimum(:entry),
      roadbed_lines.where.not(exit: [nil, 0]).minimum(:exit)
      ].reject{|r| r.nil? || r == 0}.min
  end

  def maximum
    [
      roadbed_lines.where.not(entry: [nil, 0]).maximum(:entry),
      roadbed_lines.where.not(exit: [nil, 0]).maximum(:exit)
      ].reject{|r| r.nil? || r == 0}.max
  end
end
