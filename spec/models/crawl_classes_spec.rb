require 'spec_helper'

describe CrawlClasses do
  describe "#perform" do
    it "works" do
      VCR.use_cassette('studio/classes') do
        CrawlStudios.new.perform
        subject.perform
        calendar = Studio.find_by_slug("north_hills_center").calendar
        calendar.split("\n").count.should == 445
      end
    end
  end
end
