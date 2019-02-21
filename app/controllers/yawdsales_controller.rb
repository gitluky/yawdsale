class YawdsalesController < ApplicationController

  get '/yawdsales' do
    if Helpers.logged_in?(session)
      current_user = Helpers.current_user(session)
      @map_string = "https://maps.googleapis.com/maps/api/staticmap?center=#{current_user.latitude},#{current_user.longitude}&zoom=13&size=640x500"
      @nearby_yawdsales = Yawdsale.near(current_user, 5, :order => "distance")
      letter = "A"
      @nearby_yawdsales.each do |yawdsale|
        if yawdsale.end_time > DateTime.now
          @map_string += "&markers=color:red%7Clabel:#{letter}%7C#{yawdsale.latitude}%2C#{yawdsale.longitude}"
          letter = letter.next
        end
      end
      @map_string += "&key=#{File.read('./../apikey.txt')}"
      erb :'/yawdsales/index'
    else
      redirect '/'
    end
  end

  get '/yawdsales/search' do
    address = [params[:street_address], params[:city], params[:state], params[:zipcode]].compact.join(',')
    case params[:distance]
      when "1"
        zoom=13
      when "5"
        zoom=12
      when "10"
        zoom=11
    end
    @map_string = "https://maps.googleapis.com/maps/api/staticmap?center=#{address.gsub(' ','+')}&zoom=#{zoom}&size=640x500"
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
    binding.pry
    if params.values.any? &:empty?
      flash[:params] = params
      flash[:message] = "Please fill in all fields."
      redirect "/yawdsales/new"
    elsif params[:start_time] < DateTime.now || params[:end_time] < DateTime.now || params[:end_time] < params[:end_time]
      flash[:message] = "Please verify dates."
      redirect "/yawdsales/new"
    else
      current_user = Helpers.current_user(session)
      @yawdsale = Yawdsale.create(title: params[:title], description: params[:description], street_address: params[:street_address], city: params[:city], state: params[:state], zipcode: params[:zipcode], start_time: params[:start_time], end_time: params[:end_time])
      @yawdsale.user = current_user

      path = "./public/yawdsales/#{@yawdsale.id}/photos"
      FileUtils.mkdir_p path

      if !!params[:photos]
        params[:photos].each do |photo|
          filename = photo[:filename]
          file = photo[:tempfile]

          new_photo = Photo.create(filename: filename)
          @yawdsale.photos << new_photo

          File.write("#{path}/#{new_photo.id}", file.read)

        end
      end

      @yawdsale.save
      redirect "/yawdsales/#{@yawdsale.id}"
    end
  end

  get '/yawdsales/:id' do
    @yawdsale = Yawdsale.find_by_id(params[:id])

    erb :'/yawdsales/show_yawdsale'
  end

  get '/yawdsales/:id/edit' do
    @yawdsale = Yawdsale.find_by_id(params[:id])

    if !@current_user == @yawdsale.user
      redirect '/yawdsale/#{@yawdsale.id}'
    end


    erb :'/yawdsales/edit'
  end

  patch '/yawdsales/:id' do
    binding.pry
    @yawdsale = Yawdsale.find_by_id(params[:id])
    @yawdsale.update(title: params[:title], description: params[:description], street_address: params[:street_address], city: params[:city], state: params[:state], zipcode: params[:zipcode], start_time: params[:start_time], end_time: params[:end_time])

    redirect "/yawdsales/#{@yawdsale.id}"
  end


  delete '/yawdsales/:id' do
    yawdsale = Yawdsale.find_by_id(params[:id])
    path = "./public/yawdsales/#{yawdsale.id}"
    if Dir.exists?(path)
      FileUtils.remove_dir(path, force = false)
    end
    if Helpers.current_user(session) == yawdsale.user
      Yawdsale.destroy(params[:id])
      redirect "/users/#{Helpers.current_user(session).id}"
    else
      redirect "/yawdsales/#{params[:id]}"
    end
  end







end
