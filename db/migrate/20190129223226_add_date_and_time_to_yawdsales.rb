class AddDateAndTimeToYawdsales < ActiveRecord::Migration[5.2]
  def change
    add_column :yawdsales, :start_time, :datetime
    add_column :yawdsales, :end_time, :datetime
  end
end
