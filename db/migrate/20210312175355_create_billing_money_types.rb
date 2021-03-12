class CreateBillingMoneyTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :billing_money_types do |t|
      t.string :sym_code, null: false

      t.timestamps
    end
    add_index :billing_money_types, :sym_code, unique: true
  end
end
