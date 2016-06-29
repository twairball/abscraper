class Abscraper::ListingPage
  attr_accessor :page, :results

  def initialize(url: nil)
    agent = Mechanize.new
    @page = agent.get(url)
    @results = {} # init empty hash

  end

  def scrape_page
    # title, desc
    name = @page.at("h1[itemprop=name]").text
    desc = @page.at("#details").css("span")[1].text # details in 2nd span, after "About this listing"

    # province, district, city
    address_string = @page.at("#display-address")["data-location"]
    city = address_string.split(",")[0].strip
    district = address_string.split(",")[0].strip

    # room_type we want as an enum
    room_type_string = @page.css("#summary").css("div.col-sm-3")[3].text

    if room_type_string.blank?
      # room_type is probably entire home, shift by 1
      room_type_string = @page.css("#summary").css("div.col-sm-3")[4].text
      room_type = room_type_string.downcase.include?("entire") ? 1 : 0

      capacity = @page.css("#summary").css("div.col-sm-3")[5].text.split("Guests").first.chop
      bedrooms = @page.css("#summary").css("div.col-sm-3")[6].text.split("Bedroom").first.chop
      beds = @page.css("#summary").css("div.col-sm-3")[7].text.split("Bed").first.chop
    else
      # room type is probably private room
      room_type = room_type_string.downcase.include?("entire") ? 1 : 0
      
      capacity = @page.css("#summary").css("div.col-sm-3")[4].text.split("Guests").first.chop
      bedrooms = 1  # private room
      beds = @page.css("#summary").css("div.col-sm-3")[5].text.split("Bed").first.chop
    end

    # get photos, will get top 5 or so only to reduce load
    # full photo gallery hidden behind a modal gallery
    photos = []
    @page.css(".photo-grid-photo > img").each do |photo_node|
      
      # remove cdn prcessing
      image_url = photo_node["src"].split("?").first   
      photos << {remote_image_url: image_url}
    end

    ## initialize listing object and return
    # @listing = Abscraper::Listing.new(name: name, desc: desc, room_type: room_type, 
    #     capacity: capacity, bedrooms: bedrooms, beds: beds, photos: photos)

    ## make results has
    @results = {
      name: name,
      desc: desc,
      
      # location
      city: city,
      district: district,

      # apt info
      room_type: room_type,
      capacity: capacity,
      bedrooms: bedrooms,
      beds: beds,

      # photos
      photos_attributes: photos
    }
    return results
  end



end
