require 'rails_helper'

RSpec.describe HighwayStructure, type: :model do


  describe ".open_inspection" do

    let!(:test_bridge) { create(:bridge) }
    let!(:test_inspection) { create(:bridge_condition, highway_structure: test_bridge.highway_structure, state: 'final', name: 'Insp ABC', notes: 'we want to copy this') }
    let!(:test_element) { create(:element, inspection: test_inspection.inspection, notes: 'we want to copy this element') }
    let!(:test_defect) { create(:defect, inspection: test_inspection.inspection, element: test_element, notes: 'we want to copy this defect') }

    it 'returns not final one if already exists' do

      expect(test_bridge.open_inspection).not_to eq(test_inspection)

      test_inspection.update(state: 'open')
      expect(test_bridge.open_inspection).to eq(test_inspection)

      test_inspection.update(state: 'assigned')
      expect(test_bridge.open_inspection).to eq(test_inspection)

    end

    describe 'if no inspections' do
      it 'creates new typed inspection if typed asset' do
        test_bridge.inspections = []

        expect(test_bridge.open_inspection).to be_a_new(BridgeCondition)
      end
      it 'creates new inspection if HighwayStructure' do
        test_highway_structure = create(:highway_structure)

        expect(test_highway_structure.open_inspection).to be_a_new(Inspection)
        expect(test_highway_structure.inspections.empty?).to eq(false)
      end
    end


    it "copies" do

      copy = test_bridge.open_inspection

      expect(copy.name).to eq(test_inspection.name)
      expect(copy.name).to eq('Insp ABC')

      expect(copy.notes).to eq(test_inspection.notes)
      expect(copy.notes).to eq('we want to copy this')
      expect(copy.elements.first.notes).to eq(test_inspection.elements.first.notes)
      expect(copy.elements.first.notes).to eq('we want to copy this element')
      expect(copy.elements.first.defects.first.notes).to eq(test_inspection.elements.first.defects.first.notes)
      expect(copy.elements.first.defects.first.notes).to eq('we want to copy this defect')
    end

    it 'resets state' do
      expect(test_bridge.open_inspection.state).to eq('open')
    end

    it 'resets some fields' do
      copy = test_bridge.open_inspection

      expect(copy.event_datetime).to eq(nil)
      expect(copy.qc_inspector_id).to eq(nil)
      expect(copy.qa_inspector_id).to eq(nil)
      expect(copy.routine_report_submitted_at).to eq(nil)
    end

    it 'copies child elements' do
      test_child_element = create(:element, inspection: test_inspection.inspection, notes: 'we want to copy this child element', parent: test_element)

      copy = test_bridge.open_inspection

      expect(copy.elements.first).to eq(copy.elements.last.parent)
      expect(copy.elements.first.parent).to eq(nil)
      expect(copy.elements.last.parent).not_to eq(nil)
    end
  end
end
