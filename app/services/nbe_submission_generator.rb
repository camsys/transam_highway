class NbeSubmissionGenerator
  @@state_code = Rails.application.config.state_code[0..1] || '99'

  def self.xml_for_elements(inspections)
    ade_class_ids = ElementClassification.where(name: 'ADE').pluck(:id)
    fhwa_invalid_numbers = [260, 326, 600]

    xml = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
      xml.FHAElement do
        HighwayStructure.where(id: inspections.pluck(:transam_asset_id).uniq).each do |hs|
          next unless hs.inspections.final.exists?
          hs.inspections.ordered.final.first.elements.includes(:parent)
            .includes(defects: :defect_locations)
            .includes(:element_definition).where.not(element_definitions: {element_classification_id: ade_class_ids})
            .where.not(element_definitions: {number: fhwa_invalid_numbers})
            .order(:number)
            .each do |element|
            fhwaed_for_element(xml, hs.asset_tag, element)
          end
        end
      end
    end
    xml
  end

  def self.fhwaed_for_element(xml, asset_tag, element)
    sums = Hash.new(0)
    element.defects.each {|d| d.defect_locations.each {|dl| sums[dl.condition_state] += dl.quantity}}
    sums.delete('CS1')
    xml.FHWAED do
      xml.STATE @@state_code
      xml.STRUCNUM asset_tag
      xml.EN element.element_definition.number
      xml.EPN element.parent.element_definition.number if element.parent
      xml.TOTALQTY element.quantity.round
      xml.CS1 element.quantity.round - sums.values.sum(&:round)
      xml.CS2 sums['CS2'].round
      xml.CS3 sums['CS3'].round
      xml.CS4 sums['CS4'].round
    end
  end
end
