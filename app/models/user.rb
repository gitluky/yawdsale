class User < ActiveRecord::Base
  has_many :yawdsales
  has_many :images, :through :yawdsales
  
end
