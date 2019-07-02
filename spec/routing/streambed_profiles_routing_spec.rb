require "rails_helper"

RSpec.describe StreambedProfilesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/streambed_profiles").to route_to("streambed_profiles#index")
    end

    it "routes to #new" do
      expect(:get => "/streambed_profiles/new").to route_to("streambed_profiles#new")
    end

    it "routes to #show" do
      expect(:get => "/streambed_profiles/1").to route_to("streambed_profiles#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/streambed_profiles/1/edit").to route_to("streambed_profiles#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/streambed_profiles").to route_to("streambed_profiles#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/streambed_profiles/1").to route_to("streambed_profiles#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/streambed_profiles/1").to route_to("streambed_profiles#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/streambed_profiles/1").to route_to("streambed_profiles#destroy", :id => "1")
    end
  end
end
