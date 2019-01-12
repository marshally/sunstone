require 'icalendar/tzinfo'

class CrawlClasses
  START_DT=Time.now.strftime("%Y-%m-%d")
  END_DT=1.month.from_now.strftime("%Y-%m-%d")
  SCHEDULE_URL="https://www.sunstonefit.com/DesktopModules/XModPro/Feed.aspx?PortalId=0&xfd=FX_ClassFinder&studioid=All&type=All&pid=0&userId=-1&start=#{START_DT}&end=#{END_DT}&_=1547314453200"

  def perform
    studios_with_classes.each do |slug, classes|
      if studio = Studio.where("studio_url LIKE ?", ["%",slug.downcase].join).first
        studio.clear_calendar
        studio.calendar = calendar_for(studio, classes).to_ical
      end
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
          e.summary     = "#{klass[:klass]} (#{klass[:studio_code]})"
          e.description = klass[:klass]
          e.location    = studio.name
        end
      end
    end
  end

  def studios_with_classes
    schedule = HTTParty.get(SCHEDULE_URL).as_json

    results = Hash.new { |h, k| h[k] = [] }

    schedule.each do |entry|
      klass, room, teacher, studio = entry["title"].split(/ *[:()] */)
      results[studio] << {
        name: teacher,
        klass: klass,
        studio_code: studio,
        t_start: Time.parse(entry["start"]),
        t_end: Time.parse(entry["end"]),
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
