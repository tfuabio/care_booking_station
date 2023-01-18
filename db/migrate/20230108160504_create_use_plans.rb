class CreateUsePlans < ActiveRecord::Migration[6.1]
  def change
    create_table :use_plans do |t|
      t.integer :user_id, null: false
      t.integer :care_manager_id, null: false
      t.integer :facility_id
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.integer :status, null: false, default: 0
      t.timestamps
    end
  end
end
