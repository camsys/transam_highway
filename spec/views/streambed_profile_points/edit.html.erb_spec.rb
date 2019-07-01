require 'rails_helper'

RSpec.describe "streambed_profile_points/edit", type: :view do
  before(:each) do
    @streambed_profile_point = assign(:streambed_profile_point, StreambedProfilePoint.create!())
  end

  it "renders the edit streambed_profile_point form" do
    render

    assert_select "form[action=?][method=?]", streambed_profile_point_path(@streambed_profile_point), "post" do
    end
  end
end
