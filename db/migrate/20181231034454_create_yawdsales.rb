class CreateYawdsales < ActiveRecord::Migration[5.2]
  def change
    create_table :yawdsales do |t|
      t.string :title
      t.string :description
      t.integer :user_id
      t.string :street_address
      t.string :city
      t.string :state
      t.integer :zipcode
      t.float :latitude
      t.float :longitude
    end
  end
end
