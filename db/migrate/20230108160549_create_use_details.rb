class CreateUseDetails < ActiveRecord::Migration[6.1]
  def change
    create_table :use_details do |t|
      t.integer :schedules_id, null: false
      t.integer :user_id, null: false
      t.integer :status, null: false
      t.timestamps
    end
  end
end
