class Studio < ActiveRecord::Base

  def to_param
    slug
  end

  def calendar
    Rails.cache.read("#{slug}/ics")
  end

  def self.crawl_classes
    body = HTTParty.get schedule_url

    doc = Nokogiri::HTML body

    results = Hash.new

    doc.css('table.mGrid').each do |table|
      day = nil
      table.css('tr').each do |tr|
        if th = tr.at_css('th.grid-col-date')
          day = th.content.strip
        else
          dt = tr.at_css('span.hc_date').content.strip
          klass = tr.at_css('span.classname').content.strip.gsub(/1 - T\d\d /, "")
          name = tr.at_css('span.location').content.strip
          url = tr.at_css('span.location > a')['href']

          t_start = fix_date(day, dt.split(" - ").first)
          t_end   = fix_date(day, dt.split(" - ").last)

          results[url] ||= Array.new
          results[url] << {:name => name, :klass => klass, :t_start => t_start, :t_end => t_end}
        end
      end
    end

    require 'icalendar/tzinfo'
    results.each do |url, classes|
      studio = Studio.find_by_studio_url(url)

      next if studio.nil?
      Rails.cache.delete("#{studio.slug}/ics")

      cal = Icalendar::Calendar.new
      cal.prodid = "-//Sunstone Yoga//#{studio.name} Yoga Class Schedule//EN\n”;"

      cal.add_timezone timezone

      classes.each do |klass|
        cal.event do |e|
          e.dtstart     = Icalendar::Values::DateTime.new(klass[:t_start])
          e.dtend       = Icalendar::Values::DateTime.new(klass[:t_end])
          e.summary     = "#{klass[:klass]} (#{studio.name})"
          e.description = klass[:klass]
          e.location    = studio.name
        end
      end

      Rails.cache.write("#{studio.slug}/ics", cal.to_ical)
    end
  end

  def self.timezone
    tz.ical_timezone(Time.now, nil)
  end

  def self.tz
    TZInfo::Timezone.get "America/Chicago"
  end


  def self.fix_date(day, time)
    t = day + " " + time
    t.gsub!(/ ([AP]M)/, '\1').gsub!(/\./, ":")

    Time.zone.parse(t)
  end

  def self.crawl_studios
    body = HTTParty.get locations_url

    doc = Nokogiri::HTML body

    doc.css('a.button_gray').each do |anchor|
      href = anchor['href']
      href = "https://www.sunstonefit.com" + href if href.starts_with? "/"

      # hack for mangled old studio urls - El Dorado Crossing
      if match = /\/(\w+).aspx$/.match(href)
        href = "https://www.sunstonefit.com/#{match[1].downcase}"
      end

      t = anchor.parent.parent.parent.parent.parent.parent.parent.parent.parent

      name = t.at_css("span.title").content.gsub(/ - .*/, "")

      s = Studio.find_or_create_by_name(:name => name)
      s.studio_url = href

      location = t.at_css("span.locadd").content
      pieces = location.strip.gsub(/\t/, " ").gsub(/\r/, "").gsub("\n ", "\n").split("\n")
      s.address = pieces.join("\n")

      tr = anchor.parent.parent.parent.parent
      tr.css('div.GroupList').each do |div|
        next if div.children.count < 5
      end

      s.slug ||= s.name.downcase.gsub(/[^a-z]+/, "_")

      s.save
    end
  end

  def self.locations_url
    "https://www.sunstonefit.com/locations-schedules"
  end

  def self.schedule_url
    "https://www.sunstonefit.com/class-finder"
  end
end
