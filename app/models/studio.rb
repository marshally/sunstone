class Studio < ActiveRecord::Base
  before_save :generate_slug

  def to_param
    slug
  end

  def calendar
    Rails.cache.read(cache_key)
  end

  def cache_key
    "#{slug}/ics"
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

  private

  def generate_slug
    self.slug ||= name.downcase.gsub(/[^a-z]+/, "_")
  end
end
