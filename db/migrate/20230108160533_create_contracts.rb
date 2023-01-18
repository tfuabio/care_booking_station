class CreateContracts < ActiveRecord::Migration[6.1]
  def change
    create_table :contracts do |t|
      t.integer :facility_id, null: false
      t.integer :user_id, null: false
      t.boolean :is_contracted, null: false, default: false
      t.timestamps
    end
  end
end
