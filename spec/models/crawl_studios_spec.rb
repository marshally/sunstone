require 'spec_helper'

describe CrawlStudios do
  describe "#perform" do
    before :each do
      Rails.cache.clear
      VCR.use_cassette('studio/locations') do
        Studio.crawl_studios
      end
    end

    it "creates a studio" do
      s = Studio.find_by_slug("north_hills_center")
      # s.name.should == "North Hills Center"
      # s.address.include?("10710 Research Blvd, #326").should == true
      # s.studio_url.should == "https://www.sunstonefit.com/nhc"
      Studio.count.should == 15
    end

    it "massages URLs" do
      s = Studio.find_by_slug("north_hills_center")
      s.studio_url.should == "https://www.sunstonefit.com/nhc"
    end

    it "fixes ASPX links" do
      s = Studio.find_by_slug("eldorado_crossings")
      s.studio_url.should == "https://www.sunstonefit.com/ec"
    end
  end
end
