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
      t.string :address
      t.float :latitude
      t.float :longitute
    end
  end
end
