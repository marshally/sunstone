require 'icalendar/tzinfo'

class CrawlClasses
  def perform
    studios_with_classes.each do |slug, classes|
      if studio = Studio.where("studio_url LIKE ?", ["%",slug.downcase].join).first
        puts "found #{classes.count} classes for #{slug}"
        studio.clear_calendar
        studio.calendar = calendar_for(studio, classes).to_ical
      end
    end
  end

  private

  def schedule_url
    "https://www.sunstonefit.com/DesktopModules/XModPro/Feed.aspx?PortalId=0&xfd=FX_ClassFinder&studioid=All&type=All&pid=0&userId=-1&start=#{start_dt}&end=#{end_dt}&_=1547314453200"
  end

  def start_dt
    1.day.ago.strftime("%Y-%m-%d")
  end

  def end_dt
    1.month.from_now.strftime("%Y-%m-%d")
  end

  def calendar_for(studio, classes)
    Icalendar::Calendar.new.tap do |cal|
      cal.prodid = "-//Sunstone Yoga//#{studio.name} Yoga Class Schedule//EN\n”;"

      cal.add_timezone timezone

      classes.each do |klass|
        cal.event do |e|
          e.dtstart     = Icalendar::Values::DateTime.new(klass[:t_start])
          e.dtend       = Icalendar::Values::DateTime.new(klass[:t_end])
          e.summary     = "#{klass[:klass]} (#{klass[:studio_code]})"
          e.description = klass[:klass]
          e.location    = studio.name
        end
      end
    end
  end

  def studios_with_classes
    schedule = HTTParty.get(schedule_url).as_json

    results = Hash.new { |h, k| h[k] = [] }

    schedule.each do |entry|
      klass, room, teacher, studio = entry["title"].split(/ *[:()] */)
      results[studio] << {
        name: teacher,
        klass: klass,
        studio_code: studio,
        t_start: Time.parse(entry["start"]).in_time_zone("America/Chicago"),
        t_end: Time.parse(entry["end"]).in_time_zone("America/Chicago"),
      }
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
