class CreatePhotos < ActiveRecord::Migration[5.2]
  def change
    create_table :photos do |t|
      t.string :filename
      t.integer :yawdsale_id
    end
  end
end
