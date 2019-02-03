class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email_address
      t.string :password_digest
      t.string :street_address
      t.string :city
      t.string :state
      t.integer :zipcode
      t.float :latitude
      t.float :longitude
    end
  end
end
