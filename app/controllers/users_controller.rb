class UsersController < ApplicationController

  get '/signup' do

    erb :'users/create_user'
  end

  post '/users' do
    user = User.find_by(params[:email_address])
    if user
      
      (first_name: params[first_name], last_name: params[:last_name], email_address: params[:email_address], password: params[:password], street_address: params[:street_address], city: params[:city], state: params[:state], zipcode: params[:zipcode] )

  end

  get '/login' do
    erb :'users/login'
  end

  get '/users/:id' do

  end

  get '/users/:id/edit' do

  end

  get '/logout' do

  end

end
