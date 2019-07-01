require "rails_helper"

RSpec.describe StreambedProfilePointsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/streambed_profile_points").to route_to("streambed_profile_points#index")
    end

    it "routes to #new" do
      expect(:get => "/streambed_profile_points/new").to route_to("streambed_profile_points#new")
    end

    it "routes to #show" do
      expect(:get => "/streambed_profile_points/1").to route_to("streambed_profile_points#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/streambed_profile_points/1/edit").to route_to("streambed_profile_points#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/streambed_profile_points").to route_to("streambed_profile_points#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/streambed_profile_points/1").to route_to("streambed_profile_points#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/streambed_profile_points/1").to route_to("streambed_profile_points#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/streambed_profile_points/1").to route_to("streambed_profile_points#destroy", :id => "1")
    end
  end
end
