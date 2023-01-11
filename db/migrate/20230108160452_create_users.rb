class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.integer :care_manager_id, null: false
      t.string :last_name, null: false
      t.string :first_name, null: false
      t.string :last_name_kana, null: false
      t.string :first_name_kana, null: false
      t.string :address, null: false
      t.string :post_code, null: false
      t.string :phone_number, null: false
      t.integer :current_status, null: false, default: 0
      t.integer :care_level_status, null: false
      t.integer :gender, null: false
      t.date :birthday, null: false
      t.text :life_history
      t.text :medical_history
      t.timestamps
    end
  end
end
