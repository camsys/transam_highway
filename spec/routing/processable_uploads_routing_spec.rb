require "rails_helper"

RSpec.describe ProcessableUploadsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/processable_uploads").to route_to("processable_uploads#index")
    end

    it "routes to #create" do
      expect(:post => "/processable_uploads").to route_to("processable_uploads#create")
    end

    it "routes to #destroy" do
      expect(:delete => "/processable_uploads/1").to route_to("processable_uploads#destroy", :id => "1")
    end
  end
end
