class FindDanceEvents::Scraper

  def self.scrape_dancecal
    doc = Nokogiri::HTML(open("http://dancecal.com/"))

    doc.css(".DCEvent").each do |e|
      name = e.css(".DCEventInfoName").text
      unless FindDanceEvents::Event.find_by_name(name)
        event = FindDanceEvents::Event.new

        event.name = e.css(".DCEventInfoName").text
        event.location = e.css(".DCEventInfoWhere").text.split("City: ")[1]
        event.date = e.css(".DCEventInfoDate").text
        event.dance = e.css(".DCEventInfoDances").text
        event.desc = e.css(".DCEventInfoDesc").text

        if e.css(".DCEventInfoWhere").text.split(", ")[2]
          event.country = e.css(".DCEventInfoWhere").text.split(", ")[2]
        else
          event.country = e.css(".DCEventInfoWhere").text.split(", ")[1]
        end

        event.save
      else
        FindDanceEvents::Event.find_by_name(name)
      end
    end
    FindDanceEvents::Country.create_from_events
  end
end

#location = doc.css(".DCEventNameLocation").text
#state = doc.css(".DCEventNameLocation").text.split[1]
#name = doc.css(".DCEventInfoName").text
#date = doc.css(".DCEventIntoDAte").text
#dance = doc.css(".DCEventInfoDances").text
#url = doc.css(".DCEventInfoName a").attr("href")
#desc = doc.css(".DCEventInfoDesc").text
