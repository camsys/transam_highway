require 'rails_helper'

RSpec.describe "streambed_profiles/new", type: :view do
  before(:each) do
    assign(:streambed_profile, StreambedProfile.new())
  end

  it "renders new streambed_profile form" do
    render

    assert_select "form[action=?][method=?]", streambed_profiles_path, "post" do
    end
  end
end
