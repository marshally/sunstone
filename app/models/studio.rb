class Studio < ActiveRecord::Base

  def self.crawl_classes
    body = HTTParty.get schedule_url

    doc = Nokogiri::HTML body

    results = Hash.new

    doc.css('table.mGrid').each do |table|
      day = nil
      table.css('tr').each do |tr|
        if tr.children.first.name == "th"
          day = tr.at_css('th.grid-col-date').content.strip
        else
          dt = tr.at_css('span.hc_date').content.strip
          klass = tr.at_css('span.classname').content.strip.gsub(/1 - T\d\d /, "")
          name = tr.at_css('span.location').content.strip

          t_start = fix_date(day, dt.split(" - ").first)
          t_end   = fix_date(day, dt.split(" - ").last)

          results[name] ||= Array.new
          results[name] << {:name => name, :klass => klass, :t_start => t_start, :t_end => t_end}
        end
      end
    end

    results.each do |name, classes|
      studio = Studio.find_by_name(name)
      studio ||= Studio.find_by_name(name.gsub(/s$/, ""))
      studio ||= Studio.find_by_name(name.gsub("Center", "Centre"))
      studio ||= Studio.find_by_name("The #{name}")

      cal = RiCal.Calendar do
        classes.each do |klass|
          event do
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

    doc.css('div.grouplisttitle > a').each do |anchor|
      s = Studio.find_or_create_by_studio_url(:studio_url => anchor['href'], :name => anchor.content)
      tr = anchor.parent.parent.parent.parent
      tr.css('div.GroupList').each do |div|
        next if div.children.count < 5
        s.address = div.content.strip.gsub(/\t/, " ")
      end

      s.photo_url = "http://www.sunstoneyoga.com" + tr.at_css('img')['src']

      s.slug ||= s.name.downcase.gsub(/[^a-z]+/, "_")

      s.save if s.changed?
    end
  end

  def self.locations_url
    "http://www.sunstoneyoga.com/LocationsSchedules.aspx"
  end

  def self.schedule_url
    "http://www.sunstoneyoga.com/classfinder.aspx"
  end
end
