class User < ActiveRecord::Base
  has_secure_password
  has_many :yawdsales
  has_many :photos, through: :yawdsales

end
