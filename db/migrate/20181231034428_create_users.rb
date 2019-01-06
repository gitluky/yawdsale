class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email_address
      t.string :password_digest
    end
  end
end
