require "rails_helper"

RSpec.describe SimpleCalculatorController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/").to route_to("simple_calculator#index")
    end
  end
end
