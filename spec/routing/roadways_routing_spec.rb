require "rails_helper"

RSpec.describe RoadwaysController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/roadways").to route_to("roadways#index")
    end

    it "routes to #new" do
      expect(:get => "/roadways/new").to route_to("roadways#new")
    end

    it "routes to #show" do
      expect(:get => "/roadways/1").to route_to("roadways#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/roadways/1/edit").to route_to("roadways#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/roadways").to route_to("roadways#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/roadways/1").to route_to("roadways#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/roadways/1").to route_to("roadways#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/roadways/1").to route_to("roadways#destroy", :id => "1")
    end
  end
end
