class Abscraper::Listing
  attr_accessor :name, :desc, :province, :city, :district, :capacity, :bedrooms, :beds, :photos
  attr_reader :room_type

  def initialize(name: "", desc: "", room_type: "", province: "", city: "", district: "", capacity: 0, bedrooms: 0, beds: 0, photos: [])
    @name = name
    @desc = desc
    @room_type = room_type
    @capacity = capacity
    @bedrooms = bedrooms
    @beds = beds

    # initialize photos as array
    @photos = []
    photos.each do |p|
      @photos << p
    end

  end

  def room_type=(room_type_str)
    # private_room: 0, entire_home: 1
    @room_type = room_type_str.downcase.include?("entire") ? 1 : 0
  end

end