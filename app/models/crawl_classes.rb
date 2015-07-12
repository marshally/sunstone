require 'icalendar/tzinfo'

class CrawlClasses
  SCHEDULE_URL="https://www.sunstonefit.com/class-finder"

  def perform
    studios_with_classes.each do |url, classes|
      studio = Studio.find_by_studio_url(url)

      next if studio.nil?
      studio.clear_calendar

      studio.calendar = calendar_for(studio, classes).to_ical
    end
  end

  private

  def calendar_for(studio, classes)
    Icalendar::Calendar.new.tap do |cal|
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
    end
  end

  def studios_with_classes
    body = HTTParty.get(SCHEDULE_URL)

    doc = Nokogiri::HTML(body)

    results = Hash.new { |h, k| h[k] = [] }

    doc.css('table.mGrid').each do |table|
      day = nil
      table.css('tr').each do |tr|
        if th = tr.at_css('th.grid-col-date')
          day = th.content.strip
        else
          dt = tr.at_css('span.hc_date').content.strip
          url = tr.at_css('span.location > a')['href']

          results[url] << {
            name: tr.at_css('span.location').content.strip,
            klass: tr.at_css('span.classname').content.strip.gsub(/1 - T\d\d /, ""),
            t_start: fix_date(day, dt.split(" - ").first),
            t_end: fix_date(day, dt.split(" - ").last),
          }
        end
      end
    end

    results
  end

  def timezone
    tz.ical_timezone(Time.now, nil)
  end

  def tz
    TZInfo::Timezone.get "America/Chicago"
  end


  def fix_date(day, time)
    t = day + " " + time
    t.gsub!(/ ([AP]M)/, '\1').gsub!(/\./, ":")

    Time.zone.parse(t)
  end

end
