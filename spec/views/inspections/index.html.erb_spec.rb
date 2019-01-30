require 'rails_helper'

RSpec.describe "inspections/index", type: :view do
  before(:each) do
    assign(:inspections, [
      Inspection.create!(),
      Inspection.create!()
    ])
  end

  it "renders a list of inspections" do
    render
  end
end
