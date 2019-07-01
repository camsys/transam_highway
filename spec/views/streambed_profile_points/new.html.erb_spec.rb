require 'rails_helper'

RSpec.describe "streambed_profile_points/new", type: :view do
  before(:each) do
    assign(:streambed_profile_point, StreambedProfilePoint.new())
  end

  it "renders new streambed_profile_point form" do
    render

    assert_select "form[action=?][method=?]", streambed_profile_points_path, "post" do
    end
  end
end
