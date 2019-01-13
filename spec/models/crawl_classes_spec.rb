require 'spec_helper'

describe CrawlClasses do
  describe "#perform" do
    before :each do
      $stdout.stub(:write)
      Rails.cache.clear
      VCR.use_cassette('studio/classes') do
        CrawlStudios.new.perform
        subject.perform
      end
    end

    it "works" do
      calendar.split("\n").count.should == 1273
    end

    it "has a ICS header" do
      calendar
        .starts_with?("BEGIN:VCALENDAR\r\nVERSION:2.0\r\nPRODID:-//Sunstone Yoga//North Hills Center Yoga Class Schedule//EN\\n")
        .should be_true
    end

    it "parses classes" do
      classes.count.should == 140
    end

    it "parses class names" do
      first_class.should include("Power Flow (NHC)")
    end

    it "parses class start times" do
      first_class.should include("DTSTART:20190112T153000")
    end

    it "parses class end times" do
      first_class.should include("DTEND:20190112T170000")
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
