require 'sinatra/base'

class Helpers

  def self.current_user(session)
    @user = User.find_by_id(session[:user_id])
  end

  def self.logged_in?(session)
    !!session[:user_id]
  end

  def self.nearby_yawdsales(location_object)
    result = Yawdsale.near(location_object, 5, :order => "distance")
    nearby_yawdsales = result.select {|yawdsale| yawdsale.end_time > DateTime.now}
  end

  def self.static_map_for_yawdsales_near_location_object(location_object, nearby_yawdsales)
    map_string = "https://maps.googleapis.com/maps/api/staticmap?center=#{location_object.latitude},#{location_object.longitude}&zoom=13&size=640x500&markers=color:green%7C#{location_object.latitude},#{location_object.longitude}"
    letter = "A"
    nearby_yawdsales.each do |yawdsale|
      map_string += "&markers=color:red%7Clabel:#{letter}%7C#{yawdsale.latitude}%2C#{yawdsale.longitude}"
      letter = letter.next
    end
    map_string += "&key=#{File.read('./../apikey.txt')}"
  end

  def self.static_map_for_yawdsales_near_address(address, nearby_yawdsales, distance)

    case distance
      when "1"
        zoom=13
      when "5"
        zoom=12
      when "10"
        zoom=11
    end

    map_string = "https://maps.googleapis.com/maps/api/staticmap?center=#{address.gsub(' ','+')}&zoom=#{zoom}&size=640x500&markers=color:green%7C#{address.gsub(' ','+')}"
    letter = "A"
    nearby_yawdsales.each do |yawdsale|
      map_string += "&markers=color:red%7Clabel:#{letter}%7C#{yawdsale.latitude},#{yawdsale.longitude}"
      letter = letter.next
    end
    map_string += "&key=#{File.read('./../apikey.txt')}"
  end


end
