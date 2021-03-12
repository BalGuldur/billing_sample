class CreateBillingAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :billing_accounts do |t|
      t.integer :external_id, null: false

      t.timestamps
    end
    add_index :billing_accounts, :external_id, unique: true
  end
end
