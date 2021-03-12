class CreateBillingOperations < ActiveRecord::Migration[6.1]
  def change
    create_table :billing_operations do |t|
      t.integer :subject_id, null: false
      t.string :subject_type, null: false
      t.string :reason, null: false
      t.datetime :run_at, null: false
      t.json :context

      t.timestamps
    end
    add_index :billing_operations, :subject_id
    add_index :billing_operations, :subject_type
    add_index :billing_operations, :reason
  end
end
