class CrawlStudios
  LOCATIONS_URL="https://www.sunstonefit.com/locations-schedules"

  def perform
    locations.xpath('//a[contains(text(), "Details")]').each do |anchor|
      # print anchor
      studio = studio_for(anchor)
      # print location_of(studio)
      Studio
        .find_or_create_by_name(name: name_of(studio))
        .update_attributes(
          studio_url: href_from(anchor),
          address: location_of(studio),
        )
    end
  end

  private

  def locations
    Nokogiri::HTML HTTParty.get(LOCATIONS_URL)
  end

  def studio_for(anchor)
    anchor.parent.parent.parent.parent
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
    studio.at_css("h3.heading-primary > span").content.gsub(/ - .*/, "").strip
  end

  def location_of(studio)
    location = studio.at_css("h3.heading-primary > span").parent.parent.content
    pieces = location.strip.gsub(/\t/, "").gsub(/\r/, "").gsub(/\n\s+/, "\n").split("\n")
    pieces.pop
    pieces.join("\n")
  end
end
