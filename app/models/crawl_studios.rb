class CrawlStudios
  LOCATIONS_URL="https://www.sunstonefit.com/locations-schedules"

  def perform
    locations.css('a.button_gray').each do |anchor|
      studio = studio_for(anchor)

      s = Studio.find_or_create_by_name(name: name_of(studio))
      s.studio_url = href_from(anchor)
      s.address = location_of(studio)
      s.slug ||= s.name.downcase.gsub(/[^a-z]+/, "_")

      s.save
    end
  end

  def locations
    Nokogiri::HTML HTTParty.get(LOCATIONS_URL)
  end

  def studio_for(anchor)
    anchor.parent.parent.parent.parent.parent.parent.parent.parent.parent
  end

  def href_from(anchor)
    href = anchor['href']
    href = "https://www.sunstonefit.com" + href if href.starts_with? "/"

    # hack for mangled old studio urls - El Dorado Crossing
    if match = /\/(\w+).aspx$/.match(href)
      href = "https://www.sunstonefit.com/#{match[1].downcase}"
    end

    href
  end

  def name_of(studio)
    name = studio.at_css("span.title").content.gsub(/ - .*/, "")
  end

  def location_of(studio)
    location = studio.at_css("span.locadd").content
    pieces = location.strip.gsub(/\t/, " ").gsub(/\r/, "").gsub("\n ", "\n").split("\n")
    pieces.join("\n")
  end
end
