class CreateBillingTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :billing_transactions do |t|
      t.references :billing_account, null: false, foreign_key: true
      t.references :billing_operation, null: false, foreign_key: true
      t.references :billing_money_type, null: false, foreign_key: true
      t.float :amount, null: false

      t.timestamps
    end
  end
end
