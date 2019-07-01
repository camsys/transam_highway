require 'rails_helper'

RSpec.describe "streambed_profile_points/index", type: :view do
  before(:each) do
    assign(:streambed_profile_points, [
      StreambedProfilePoint.create!(),
      StreambedProfilePoint.create!()
    ])
  end

  it "renders a list of streambed_profile_points" do
    render
  end
end
