require 'rails_helper'

RSpec.describe "inspections/show",  type: :view do
  before(:each) do
    @inspection = assign(:inspection, Inspection.create!())

    skip('No factories yet for TransamAsset and HighwayStructure. Not yet testable.')
  end

  it "renders attributes in <p>" do
    render
  end
end
