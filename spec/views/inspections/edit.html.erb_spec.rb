require 'rails_helper'

RSpec.describe "inspections/edit", type: :view do
  before(:each) do
    @inspection = assign(:inspection, Inspection.create!())
  end

  it "renders the edit inspection form" do
    render

    assert_select "form[action=?][method=?]", inspection_path(@inspection), "post" do
    end
  end
end
