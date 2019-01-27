class User < ActiveRecord::Base
  extend Geocoder::Model::ActiveRecord

  has_many :yawdsales
  has_many :photos, through: :yawdsales

  has_secure_password

  geocoded_by :address
  reverse_geocoded_by :latitude, :longitute
  after_validation :geocode

  def address
    [street_address, city, state, zipcode].compact.join(', ')
  end

end
