class CreateBookingContacts < ActiveRecord::Migration[6.1]
  def change
    create_table :booking_contacts do |t|
      t.integer :use_plan_id, null: false
      t.integer :facility_id, null: false
      t.integer :status, null: false, default: 0
      t.timestamps
    end
  end
end
