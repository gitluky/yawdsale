class YawdsalesController < ApplicationController

  get '/yawdsales' do

    erb :'/yawdsales/index'
  end

  get '/yawdsales/new' do
    @current_user = Helpers.current_user(session)
    erb :'yawdsales/new'
  end

  post '/yawdsales' do
    binding.pry
    current_user = Helpers.current_user(session)
    current_user.yawdsales.create(params)
    redirect "/users/#{Helpers.current_user(session).id}"
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
