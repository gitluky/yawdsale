require 'rack-flash'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "somethingrandom"
    use Rack::Flash
  end

  get '/' do
    @current_user = Helpers.current_user(session)
    erb :index
  end

end
