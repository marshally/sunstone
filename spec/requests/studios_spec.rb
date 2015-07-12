require 'spec_helper'

describe "Studios" do
  describe "GET /studios" do
    it "works! (now write some real specs)" do
      get studios_path
      response.status.should be(200)
    end
  end
end
