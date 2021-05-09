require "rails_helper"

RSpec.describe Operation::BinaryOperationsController, type: :routing do
  describe "routing" do
    it "routes to #create_or_update" do
      expect(post: "/operation/binary_operations").to route_to("operation/binary_operations#create_or_update")
    end
  end
end
