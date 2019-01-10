class UsersController < ApplicationController

  get '/signup' do

    erb :'users/create_user'
  end

  post '/users' do
    user = User.find_by(email_address: params[:email_address])
    if user
      flash[:message] = 'Email address is already associated to an account, please login in'
      redirect '/'
    else
      user = User.create(first_name: params[first_name], last_name: params[:last_name], email_address: params[:email_address], password: params[:password], street_address: params[:street_address], city: params[:city], state: params[:state], zipcode: params[:zipcode])
      session[:id] = user.id
      redirect '/'
    end
  end

  patch '/users' do
    user = Helpers.current_user(session)
    if User.find_by(email_address: params[:email_address])
      flash[:message] = 'Email is already associated to an account.'
      redirect "/users/#{user.id}/edit"
    else
      user = User.update(params)
      redirect '/'
    end
  end

  get '/login' do
    erb :'users/login'
  end

  post '/login' do
    user = User.find_by(email_address: params[:email_address])
    if user && user.authenticate(params[:password])
      session[:user_id] == user.id
      redirect '/'
    else
      flash[:message] = 'Incorrect email address or password, please try again.'
      redirect '/login'
    end
  end

  get '/users/:id' do

  end

  get '/users/:id/edit' do

  end

  get '/logout' do
    session[:user_id].clear
  end

end
