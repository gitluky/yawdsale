class YawdsalesController < ApplicationController

  get '/yawdsales' do
    current_user = Helpers.current_user(session)
    @map_string = "https://maps.googleapis.com/maps/api/staticmap?center=#{current_user.latitude},#{current_user.longitude}&zoom=#{zoom}&size=640x500"
    @nearby_yawdsales = Yawdsale.near(current_user)
    letter = "A"
    @nearby_yawdsales.each do |yawdsale|
      if yawdsale.end_time > DateTime.now
        @map_string += "&markers=color:red%7Clabel:#{letter}%7C#{yawdsale.latitude}%2C#{yawdsale.longitude}"
        letter = letter.next
      end
    end
    @map_string += "&key=#{File.read('./../apikey.txt')}"
    erb :'/yawdsales/index'
  end

  get '/yawdsales/search' do
    address = [params[:street_address], params[:city], params[:state], params[:zipcode]].compact.join(',')
    case params[:distance]
    when 5
      zoom=13
    when 10
      zoom=12
    when 15
      zoom=11
    end

    @map_string = "https://maps.googleapis.com/maps/api/staticmap?center=#{address.gsub(' ','+')}&zoom=#{zoom}&size=640x500"
    binding.pry
    @search_results = Yawdsale.near(address, params[:distance])
    letter = "A"
    @search_results.each do |yawdsale|
      if yawdsale.end_time > DateTime.now
        @map_string += "&markers=color:red%7Clabel:#{letter}%7C#{yawdsale.latitude},#{yawdsale.longitude}"
        letter = letter.next
      end
    end
    @map_string += "&key=#{File.read('./../apikey.txt')}"
    erb :'/yawdsales/search'
  end

  get '/yawdsales/new' do
    @current_user = Helpers.current_user(session)
    @params = flash[:params]
    erb :'yawdsales/new'
  end

  post '/yawdsales' do
    if params.values.any? {|v| v.nil?}
      flash[:params] = params
      flash[:message] = "Please fill in all fields."
      redirect "/yawdsales/new"
    elsif params[:start_time] < DateTime.now || params[:end_time] < DateTime.now || params[:end_time] < params[:end_time]
      flash[:message] = "Please verify dates."
      redirect "/yawdsales/new"
    else
      current_user = Helpers.current_user(session)
      current_user.yawdsales.create(params)
      redirect "/users/#{Helpers.current_user(session).id}"
    end
  end

  get '/yawdsales/:id' do
    @yawdsale = Yawdsale.find_by_id(params[:id])

    erb :'/yawdsales/show_yawdsale'
  end

  get '/yawdsales/:id/edit' do

    erb :'/yawdsales/edit'
  end

  get '/yawdsales/:id/photos/:photo_id' do

    erb :'/photos/show_photo'
  end

  delete '/yawdsales/:id/delete' do


  end







end
