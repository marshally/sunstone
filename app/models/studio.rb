class Studio < ActiveRecord::Base

  def to_param
    slug
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

    results.each do |url, classes|
      studio = Studio.find_by_studio_url(url)

      next if studio.nil?

      cal = RiCal.Calendar do |cal|
        cal.add_x_property("X-WR-CALNAME", "#{studio.name} Sunstone Yoga Class Schedule")
        
        classes.each do |klass|
          cal.event do
            summary     "#{klass[:klass]} (#{studio.name})"
            description klass[:klass]
            dtstart     klass[:t_start]
            dtend       klass[:t_end]
            location    "#{studio.name}\n#{studio.address}"
          end
        end
      end.to_s

      Rails.cache.delete("#{studio.slug}/ics")
      Rails.cache.write("#{studio.slug}/ics", cal)
    end
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
      href = "http://www.sunstoneyoga.com" + href if href[0] = "/"
      t = anchor.parent.parent.parent.parent.parent.parent.parent.parent.parent.parent

      name = t.at_css("span.ctitle").content.gsub(/ - .*/, "")

      s = Studio.find_or_create_by_name(:name => name)
      s.studio_url = href

      location = t.at_css("span.locadd").content
      pieces = location.strip.gsub(/\t/, " ").gsub(/\r/, "").gsub("\n ", "\n").split("\n")
      s.address = pieces.join("\n")

      tr = anchor.parent.parent.parent.parent
      tr.css('div.GroupList').each do |div|
        next if div.children.count < 5
      end

      s.photo_url = "http://www.sunstoneyoga.com" + t.at_css('img.locimg')['src']

      s.slug ||= s.name.downcase.gsub(/[^a-z]+/, "_")

      s.save if s.changed?
    end
  end

  def self.locations_url
    "http://www.sunstoneyoga.com/locations-schedules"
  end

  def self.schedule_url
    "http://www.sunstoneyoga.com/class-finder"
  end
end
