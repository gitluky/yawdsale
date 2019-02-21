
class UsersController < ApplicationController

  get '/signup' do
    @params = flash[:params]
    @message = flash[:message]
    erb :'users/create_user'
  end

  post '/users' do
    user = User.find_by(email_address: params[:email_address])
    if user
      flash[:params] = params
      flash[:message] = "Email address is already associated to an account."
      redirect '/signup'
    elsif params.values.any? &:empty?
      flash[:message] = 'All fields must be filled in.'
      redirect '/signup'
    else
      user = User.create(first_name: params[:first_name], last_name: params[:last_name], email_address: params[:email_address], password: params[:password], street_address: params[:street_address], city: params[:city], state: params[:state], zipcode: params[:zipcode])
      session[:user_id] = user.id
      redirect '/'
    end
  end

  patch '/users' do
    current_user = Helpers.current_user(session)
    if User.find_by(email_address: params[:email_address]) && current_user.email_address != params[:email_address]
      flash[:message] = 'Email is already associated to an account.'
      redirect "/users/#{current_user.id}/edit"
    elsif params.values.any? &:empty?
      flash[:message] = 'All fields must be filled in.'
      redirect "/users/#{current_user.id}/edit"
    else
      current_user.update(first_name: params[:first_name], last_name: params[:last_name], email_address: params[:email_address], street_address: params[:street_address], city: params[:city], state: params[:state], zipcode: params[:zipcode])
      flash[:message] = "Successfully updated."
      redirect "/users/#{current_user.id}"
    end
  end

  get '/login' do
    erb :'users/login'
  end

  post '/login' do
    user = User.find_by(email_address: params[:email_address])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect '/'
    else
      flash[:message] = 'Incorrect email address or password, please try again.'
      redirect '/login'
    end
  end

  get '/users/:id' do
    @current_user = Helpers.current_user(session)
    @user = User.find_by_id(params[:id])
    @active_yawdsales = @user.yawdsales.where("end_time > ?", DateTime.now)
    @previous_yawdsales = @user.yawdsales.where("end_time < ?", DateTime.now)



    erb :'/users/show'
  end

  get '/users/:id/yawdsales' do
    @current_user = Helpers.current_user(session)
    @user = User.find_by_id(params[:id])
    erb :'/users/yawdsales'
  end

  get '/users/:id/edit' do
    @current_user = Helpers.current_user(session)

    erb :'/users/edit'
  end

  get '/logout' do
    session.clear
    redirect '/'
  end

end
