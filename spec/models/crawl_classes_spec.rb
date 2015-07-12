require 'spec_helper'

describe CrawlClasses do
  describe "#perform" do
    before :each do
      Rails.cache.clear
      VCR.use_cassette('studio/classes') do
        CrawlStudios.new.perform
        subject.perform
      end
    end

    it "works" do
      calendar.split("\n").count.should == 445
    end

    it "has a ICS header" do
      calendar
        .starts_with?("BEGIN:VCALENDAR\r\nVERSION:2.0\r\nPRODID:-//Sunstone Yoga//North Hills Center Yoga Class Schedule//EN\\n")
        .should be_true
    end

    it "parses classes" do
      classes.count.should == 48
    end

    it "parses class names" do
      first_class.should include("SUMMARY:Earth")
    end

    it "parses class start times" do
      first_class.should include("DTSTART:20150627T091500")
    end

    it "parses class end times" do
      first_class.should include("DTEND:20150627T100000")
    end

    private

    def calendar
      Studio
        .find_by_slug("north_hills_center")
        .calendar
    end

    def classes
      calendar.split("\r\nDESCRIPTION")
    end

    def first_class
      classes.second
    end
  end
end
