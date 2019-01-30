require 'rails_helper'

RSpec.describe "inspections/show", type: :view do
  before(:each) do
    @inspection = assign(:inspection, Inspection.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
