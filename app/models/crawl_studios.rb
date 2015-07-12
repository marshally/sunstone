class CrawlStudios
  LOCATIONS_URL="https://www.sunstonefit.com/locations-schedules"

  def perform
    locations.css('a.button_gray').each do |anchor|
      t = anchor.parent.parent.parent.parent.parent.parent.parent.parent.parent

      name = t.at_css("span.title").content.gsub(/ - .*/, "")

      s = Studio.find_or_create_by_name(name: name)
      s.studio_url = href_from(anchor)

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

  def locations
    Nokogiri::HTML HTTParty.get(LOCATIONS_URL)
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
end
