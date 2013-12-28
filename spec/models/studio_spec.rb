require 'spec_helper'

describe Studio do
  describe ".crawl_studios" do
    it "should crawl studios" do
      VCR.use_cassette('studio/locations') do
        Studio.crawl_studios
        s = Studio.first
        s.name.should == "North Hills Center"
        s.address.include?("10710 Research Blvd, #326").should == true
        s.photo_url.should  == "http://www.sunstoneyoga.com/portals/0/Images_Locations/storefrontNHC.jpg"
        s.studio_url.should == "http://www.sunstoneyoga.com/nhc"
        Studio.count.should == 13
      end
    end


    describe ".crawl_classes" do
      it "should crawl studios" do
        VCR.use_cassette('studio/classes') do # , :record => :new_episodes
          Studio.crawl_studios
          Studio.crawl_classes
        end
      end
    end
  end
  
  describe "#calendar" do
    it "should fetch the calendar info"
    it "should hit cache inside the ttl"
    it ""
  end
end
