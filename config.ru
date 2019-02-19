require_relative './config/environment.rb'

use Rack::MethodOverride
use UsersController
use YawdsalesController
use PhotosController
run ApplicationController
