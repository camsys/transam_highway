require 'rails_helper'

RSpec.describe "streambed_profiles/index", type: :view do
  before(:each) do
    assign(:streambed_profiles, [
      StreambedProfile.create!(),
      StreambedProfile.create!()
    ])
  end

  it "renders a list of streambed_profiles" do
    render
  end
end
