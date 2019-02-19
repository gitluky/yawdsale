class YawdsalesController < ApplicationController

  get '/yawdsales' do
    if Helpers.logged_in?(session)
      current_user = Helpers.current_user(session)
      @map_string = "https://maps.googleapis.com/maps/api/staticmap?center=#{current_user.latitude},#{current_user.longitude}&zoom=12&size=640x500"
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
    if params.values.any? {|v| v.nil?}
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

      path = "./public/#{@yawdsale.id}/photos"
      FileUtils.mkdir_p path

      params[:photos].each do |photo|
        filename = photo[:filename]
        file = photo[:tempfile]

        File.write("#{path}/#{filename}", file.read)

        @yawdsale.photos.create(filename: filename)

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

  # get '/yawdsales/:id/photos/new' do
  #   @yawdsale = Yawdsale.find_by_id(params[:id])
  #   erb :'/photos/new'
  # end

  # post '/yawdsales/:id/photos' do
  #
  #   current_user = Helpers.current_user(session)
  #   yawdsale = Yawdsale.find_by_id(params[:id])
  #   yawdsale_photos = Photo.where("yawdsale_id = #{yawdsale.id}")
  #
  #   if !yawdsale_photos.empty?
  #     redirect "/yawdsales/#{yawdsale.id}"
  #   end
  #
  #   path = "./public/#{yawdsale.id}/photos"
  #   FileUtils.mkdir_p path
  #
  #   binding.pry
  #
  #   params[:photos].each do |photo|
  #     filename = photo[:filename]
  #     file = photo[:tempfile]
  #
  #     #File.open("./public/#{current_user}/#{filename}", 'wb') do |f|
  #     File.write("#{path}/#{filename}", file.read)
  #     #end
  #
  #     yawdsale.photos.create(filename: filename)
  #   end
  #     redirect "/yawdsales/#{params[:id]}"
  # end

  # patch '/yawdsales/:id/photos' do
  #   current_user = Helpers.current_user(session)
  #   yawdsale = Yawdsale.find_by_id(params[:id])
  #   yawdsale_photos = Photo.where("yawdsale_id = #{yawdsale.id}")
  #   photo_count = yawdsale_photos.count || 0
  #
  #
  #   params[:photos].each do |photo|
  #     if photo_count < 3
  #       filename = photo[:filename]
  #       file = photo[:tempfile]
  #
  #       File.open("./public/#{yawdsale.id}/#{filename}", 'wb') do |f|
  #          f.write(file.read)
  #       end
  #
  #       current_user.photos.create(filename: filename)
  #       photo_count +=1
  #     else
  #       flash[:message] = "There is a 3 photo limit per Yawdsale. Delete photos to add more."
  #
  #     end
  #   end
  #     redirect "/yawdsales/#{params[:id]}"
  # end

  get '/yawdsales/:id/photos/:photo_id' do
    @yawdsale = Yawdsale.find_by_id(params[:id])
    @photo = Photo.find_by_id(params[:photo_id])


    erb :'/photos/show_photo'
  end

  delete '/yawdsales/:id' do
    yawdsale = Yawdsale.find_by_id(params[:id])
    path = "./public/#{yawdsale.id}"
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
