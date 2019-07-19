class Roadbed < ApplicationRecord
  include TransamObjectKey
  
  belongs_to :roadway
  has_one :left_edge, -> { where(number: ['L']).limit(1) }, class_name: "RoadbedLine"
  has_one :right_edge, -> { where(number: ['R']).limit(1) }, class_name: "RoadbedLine"
  has_many :roadbed_lines, -> { where.not(number: ['L', 'R']).order(:number) }

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
      roadbed.create_left_edge(number: 'L', inspection: inspection)
      roadbed.create_right_edge(number: 'R', inspection: inspection)
      (1..roadbed.number_of_lines).each do |line_number|
        roadbed.roadbed_lines.create(number: line_number, inspection: inspection)
      end
    end
  end

  def minimum
    [
      left_edge&.entry,
      left_edge&.exit,
      right_edge&.entry,
      right_edge&.exit,
      roadbed_lines.minimum(:entry),
      roadbed_lines.minimum(:exit)
      ].reject{|r| r.nil?}.min
  end

  def maximum
    [
      left_edge&.entry,
      left_edge&.exit,
      right_edge&.entry,
      right_edge&.exit,
      roadbed_lines.maximum(:entry),
      roadbed_lines.maximum(:exit)
      ].reject{|r| r.nil?}.max
  end
end
