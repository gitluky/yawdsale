class YawdsalesController < ApplicationController

  get '/yawdsales' do
    if Helpers.logged_in?(session)
      current_user = Helpers.current_user(session)
      @nearby_yawdsales = Helpers.nearby_yawdsales(current_user)
      @map_string = Helpers.static_map_for_yawdsales_near_location_object(current_user, @nearby_yawdsales)
      erb :'/yawdsales/index'
    else
      redirect '/login'
    end
  end

  get '/yawdsales/search' do
    if Helpers.logged_in?(session)
      @current_user = Helpers.current_user(session)
      address = [params[:street_address], params[:city], params[:state], params[:zipcode]].compact.join(',')
      @nearby_yawdsales = Helpers.nearby_yawdsales(address)
      @map_string = Helpers.static_map_for_yawdsales_near_address(address, @nearby_yawdsales, params[:distance])

      erb :'/yawdsales/search'
    else
      redirect '/login'
    end
  end

  get '/yawdsales/new' do
    if Helpers.logged_in?(session)
      @current_user = Helpers.current_user(session)
      @params = flash[:params]
      erb :'yawdsales/new'
    else
      redirect '/login'
    end
  end

  post '/yawdsales' do
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
    binding.pry
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
