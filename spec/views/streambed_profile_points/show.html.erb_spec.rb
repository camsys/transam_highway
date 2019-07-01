require 'rails_helper'

RSpec.describe "streambed_profile_points/show", type: :view do
  before(:each) do
    @streambed_profile_point = assign(:streambed_profile_point, StreambedProfilePoint.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
