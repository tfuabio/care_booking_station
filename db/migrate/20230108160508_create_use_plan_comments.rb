class CreateUsePlanComments < ActiveRecord::Migration[6.1]
  def change
    create_table :use_plan_comments do |t|
      t.integer :use_plan_id, null: false
      t.boolean :is_facility, null: false
      t.text :comment, null: false
      t.timestamps
    end
  end
end
