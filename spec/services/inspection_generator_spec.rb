require 'rails_helper'

RSpec.describe InspectionGenerator, type: :service do


  describe ".create" do

    let!(:test_bridge) { create(:bridge) }
    let!(:test_inspection_type) { create(:inspection_type) }

    let!(:test_inspection_type_setting) { create(:inspection_type_setting, highway_structure: test_bridge.highway_structure, inspection_type: test_inspection_type) }
    let!(:test_inspection) { create(:bridge_condition, highway_structure: test_bridge.highway_structure, state: 'final', notes: 'we want to copy this', inspection_type: test_inspection_type, inspection_type_setting: test_inspection_type_setting) }
    let!(:test_element) { create(:element, inspection: test_inspection.inspection, notes: 'we want to copy this element') }
    let!(:test_defect) { create(:defect, inspection: test_inspection.inspection, element: test_element, notes: 'we want to copy this defect') }


    it 'returns not final one if already exists' do
      BridgeCondition.where.not(id: test_inspection.id).destroy_all # delete generated inspection from inspection type setting callback to create scenario for test
      generator = InspectionGenerator.new(test_inspection_type_setting)

      expect(generator.create).not_to eq(test_inspection)

      test_inspection.update!(state: 'open')

      expect(generator.create).to eq(test_inspection)

      test_inspection.update!(state: 'assigned')
      expect(generator.create).to eq(test_inspection)

    end

    describe 'if no inspections' do
      it 'creates new typed inspection if typed asset' do
        test_bridge.inspections = []
        generator = InspectionGenerator.new(test_inspection_type_setting)

        expect(generator.create).to be_a(BridgeCondition)
        expect(test_bridge.inspections.count).to eq(1)
      end
      it 'creates new inspection if HighwayStructure', :skip do
        generator = InspectionGenerator.new(test_inspection_type_setting)
        test_highway_structure = create(:highway_structure)

        expect(test_highway_structure.open_inspection).to be_a_new(Inspection)
        expect(test_highway_structure.inspections.empty?).to eq(false)
      end
    end


    it "copies" do
      BridgeCondition.where.not(id: test_inspection.id).destroy_all # delete generated inspection from inspection type setting callback to create scenario for test
      generator = InspectionGenerator.new(test_inspection_type_setting)

      copy = generator.create

      expect(copy.notes).to eq(test_inspection.notes)
      expect(copy.notes).to eq('we want to copy this')
      expect(copy.elements.first.notes).to eq(test_inspection.elements.first.notes)
      expect(copy.elements.first.notes).to eq('we want to copy this element')
      expect(copy.elements.first.defects.first.notes).to eq(test_inspection.elements.first.defects.first.notes)
      expect(copy.elements.first.defects.first.notes).to eq('we want to copy this defect')
    end

    it 'resets state' do
      generator = InspectionGenerator.new(test_inspection_type_setting)
      expect(generator.create.state).to eq('open')
    end

    it 'resets some fields' do
      generator = InspectionGenerator.new(test_inspection_type_setting)
      copy = generator.create

      expect(copy.event_datetime).to eq(nil)
      expect(copy.qc_inspector_id).to eq(nil)
      expect(copy.qa_inspector_id).to eq(nil)
      expect(copy.routine_report_submitted_at).to eq(nil)
    end

    it 'copies child elements' do
      BridgeCondition.where.not(id: test_inspection.id).destroy_all # delete generated inspection from inspection type setting callback to create scenario for test
      test_child_element = create(:element, inspection: test_inspection.inspection, notes: 'we want to copy this child element', parent: test_element)

      generator = InspectionGenerator.new(test_inspection_type_setting)
      copy = generator.create

      expect(copy.elements.first).to eq(copy.elements.last.parent)
      expect(copy.elements.first.parent).to eq(nil)
      expect(copy.elements.last.parent).not_to eq(nil)
    end
  end
end
