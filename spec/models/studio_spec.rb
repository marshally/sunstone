require 'spec_helper'

describe Studio do
  describe ".crawl_studios" do
    it "should crawl studios" do
      VCR.use_cassette('studio/locations') do # , :record => :new_episodes
        Studio.crawl_studios
        s = Studio.first
        s.name.should == "Centre at Preston Ridge"
        s.address.include?("8250 Gaylord Parkway,").should == true
        s.photo_url.should  == "http://www.sunstoneyoga.com/DesktopModules/VivoGroups/ImageHandler.ashx?width=90&height=0&portalId=0&moduleId=2104&mediaId=13&q=1&fullScale=0&s=0"
        s.studio_url.should == "http://www.sunstoneyoga.com/LocationsSchedules/tabid/63/view/groupdetail/groupid/15/fview/groupslist/categoryid/5/Default.aspx"
        Studio.count.should == 13
      end
    end

    describe ".crawl_classes" do
      it "should crawl studios" do
        VCR.use_cassette('studio/classes', :record => :new_episodes) do # , :record => :new_episodes
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
