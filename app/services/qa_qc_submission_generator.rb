class QaQcSubmissionGenerator
  def self.xml_for_structures(global_ids)
    xml = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
      xml.Pontis_BridgeExport do
        global_ids.each do |global_id|
          selected_inspection = Inspection.get_typed_inspection(GlobalID::Locator.locate(global_id))
          structure = TransamAsset.get_typed_asset(selected_inspection.highway_structure)
          last_final_inspection = Inspection.get_typed_inspection(structure.inspections.ordered.final.first)
          brkey = structure.asset_tag
          structure_class = structure.class.name
          # Fracture Critical inspections
          fc_type = InspectionType.find_by(code: 'G')
          fc_required = structure.inspection_type_settings.where(inspection_type: fc_type, is_required: true).exists?
          fc_last_date = structure.inspections.ordered.final.where(inspection_type: fc_type).pluck(:event_datetime).first
          xml.bridge do
            xml.BRKEY brkey
            xml.LENGTH structure.length
            xml.SERVTYPON structure.service_on_type&.code
            xml.ORTYPE structure.operating_rating_method_type&.code
            xml.ORLOAD structure.operating_rating
            xml.IRTYPE structure.inventory_rating_method_type&.code
            xml.IRLOAD structure.inventory_rating
            xml.POSTING structure.bridge_posting_type&.code
            xml.USERKEY4 selected_inspection.inspection_trip
          end
          xml.userbrdg do
            xml.BRKEY brkey
            xml.STRUCTTYPE structure.highway_structure_type&.code
          end
          roadway = structure.roadways.on.first
          if roadway
            xml.roadway do
              xml.BRKEY brkey
              xml.ADDTTOTAL roadway.average_daily_traffic
            end
          end
          xml_for_inspection(xml, selected_inspection, brkey, structure_class, fc_required, fc_last_date)
          xml_for_inspection(xml, last_final_inspection, brkey, structure_class, fc_required, fc_last_date)
        end
      end
    end
  end

  def self.xml_for_inspection(xml, inspection, brkey, structure_class, fc_required, fc_last_date)
    return unless inspection
    team_leader = inspection.inspection_team_leader
    xml.inspevnt do
      xml.BRKEY brkey
      xml.INSPKEY inspection.object_key
      xml.INSPDATE inspection.event_datetime&.xmlschema
      xml.INSPNAME team_leader.name if team_leader
      xml.INSPTYPE inspection.inspection_type&.code
      xml.BRINSPFREQ inspection.inspection_type_setting.frequency_months
      case structure_class
      when 'Bridge'
        xml.DKRATING inspection.deck_condition_rating_type&.code
        xml.SUPRATING inspection.superstructure_condition_rating_type&.code
        xml.SUBRATING inspection.substructure_condition_rating_type&.code
      when 'Culvert'
        xml.CULVRATING inspection.culvert_condition_type&.code
      end
      xml.STRRATING inspection.structural_appraisal_rating_type&.code
      xml.SCOURCRIT inspection.scour_critical_bridge_type&.code
      xml.DECKGEOM inspection.deck_geometry_appraisal_rating_type&.code
      xml.APPRALIGN inspection.approach_alignment_appraisal_rating_type&.code
      xml.OPPOSTCL inspection.operational_status_type&.code
      xml.FCINSPREQ fc_required ? 'Y' : 'N'
      xml.FCLASTINSP fc_last_date.xmlschema if fc_last_date
    end
    other = inspection.inspectors.where.not(id: team_leader).first
    if other
      xml.userinsp do
        xml.OTHER_INSP_NAME other.name
      end
    end
  end
end
