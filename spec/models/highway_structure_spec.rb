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
  end
end
