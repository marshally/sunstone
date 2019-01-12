require 'spec_helper'

describe CrawlStudios do
  describe "#perform" do
    before :each do
      Rails.cache.clear
      VCR.use_cassette('studio/locations') do
        CrawlStudios.new.perform
      end
    end

    it "creates studios" do
      Studio.count.should == 15
    end

    it "parses names" do
      s = Studio.find_by_slug("north_hills_center")
      s.name.should == "North Hills Center"
    end

    it "parses addresses" do
      s = Studio.find_by_slug("north_hills_center")
      s.address.include?("10710 Research Blvd, #326").should == true
    end

    it "each studio address should be unique" do
      addresses = Studio.all.map(&:address)
      addresses.should eq(addresses.uniq)
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
