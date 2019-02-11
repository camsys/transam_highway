require 'rails_helper'

RSpec.describe "inspections/new", type: :view do
  before(:each) do
    assign(:inspection, Inspection.new())
  end

  it "renders new inspection form" do
    render

    assert_select "form[action=?][method=?]", inspections_path, "post" do
    end
  end
end
