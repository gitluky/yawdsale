class Yawdsale < ActiveRecord::Base
  extend Geocoder::Model::ActiveRecord

  belongs_to :user
  has_many :photos

  geocoded_by :address
  reverse_geocoded_by :latitude, :longitude
  after_validation :geocode

  def address
    [street_address, city, state, zipcode].compact.join(', ')
  end

end
