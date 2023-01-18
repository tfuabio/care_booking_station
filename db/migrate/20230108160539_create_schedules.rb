class CreateSchedules < ActiveRecord::Migration[6.1]
  def change
    create_table :schedules do |t|
      t.integer :facility_id, null: false
      t.date :date, null: false
      t.timestamps
    end
  end
end
