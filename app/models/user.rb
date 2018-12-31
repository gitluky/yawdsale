class User < ActiveRecord::Base
  has_many :yawdsales
  has_many :photos, through: :yawdsales

end
