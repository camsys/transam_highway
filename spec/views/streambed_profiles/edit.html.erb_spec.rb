require 'rails_helper'

RSpec.describe "streambed_profiles/edit", type: :view do
  before(:each) do
    @streambed_profile = assign(:streambed_profile, StreambedProfile.create!())
  end

  it "renders the edit streambed_profile form" do
    render

    assert_select "form[action=?][method=?]", streambed_profile_path(@streambed_profile), "post" do
    end
  end
end
