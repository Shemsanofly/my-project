class CreatePaymentTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :payment_transactions do |t|
      t.references :booking, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :provider, null: false, default: "stripe"
      t.string :provider_payment_id, null: false
      t.string :status, null: false, default: "pending"
      t.integer :amount_cents, null: false, default: 0
      t.string :currency, null: false, default: "usd"
      t.jsonb :metadata, null: false, default: {}

      t.timestamps
    end

    add_index :payment_transactions, :provider_payment_id, unique: true
    add_index :payment_transactions, :status
  end
end
