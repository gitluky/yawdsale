class YawdsalesController < ApplicationController

  get '/yawdsales' do

    erb :'/yawdsales/index'
  end

  get '/yawdsales/new' do
    @current_user = Helpers.current_user(session)
    erb :'yawdsales/new'
  end

  post '/yawdsales' do
    current_user = Helpers.current_user(session)
    current_user.yawdsales.create(params)
    redirect "/users/#{Helpers.current_user(session).id}/yawdsales"
  end

  get '/yawdsales/:id' do

    erb :'/yawdsales/show'
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
