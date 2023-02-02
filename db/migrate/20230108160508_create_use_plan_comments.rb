class CreateUsePlanComments < ActiveRecord::Migration[6.1]
  def change
    create_table :use_plan_comments do |t|
      t.integer :use_plan_id, null: false
      t.integer :speaker_id, null: false, default: 0
      t.text :comment, null: false
      t.decimal :score, precision: 5, scale: 3
      t.timestamps
    end
  end
end
