require 'rails_helper'

RSpec.describe "streambed_profiles/show", type: :view do
  before(:each) do
    @streambed_profile = assign(:streambed_profile, StreambedProfile.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
