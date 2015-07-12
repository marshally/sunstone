require 'spec_helper'

describe Studio do
  describe ".crawl_studios" do
    it "should crawl studios" do
      VCR.use_cassette('studio/locations') do
        Studio.crawl_studios
        s = Studio.find_by_slug("north_hills_center")
        s.name.should == "North Hills Center"
        s.address.include?("10710 Research Blvd, #326").should == true
        s.studio_url.should == "https://www.sunstonefit.com/nhc"
        Studio.count.should == 15
      end
    end
  end

  describe "#calendar" do
    it "should fetch the calendar info"
    it "should hit cache inside the ttl"
    it ""
  end
end
