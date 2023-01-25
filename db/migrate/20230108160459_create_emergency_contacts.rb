class CreateEmergencyContacts < ActiveRecord::Migration[6.1]
  def change
    create_table :emergency_contacts do |t|
      t.integer :user_id, null: false
      t.string :last_name, null: false
      t.string :first_name, null: false
      t.string :last_name_kana, null: false
      t.string :first_name_kana, null: false
      t.string :address, null: false
      t.string :post_code, null: false
      t.string :phone_number, null: false
      t.integer :relationship, null: false
      t.integer :status, null: false
      t.timestamps
    end
  end
end
