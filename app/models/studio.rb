class Studio < ActiveRecord::Base
  def to_param
    slug
  end

  def calendar
    Rails.cache.read("#{slug}/ics")
  end

  def filename
    "#{slug}.ics"
  end

  def self.crawl_classes
    CrawlClasses.new.perform
  end

  def self.crawl_studios
    CrawlStudios.new.perform
  end
end
