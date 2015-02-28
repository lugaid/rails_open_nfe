class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.references :sender, index: true
      t.integer :number
      t.integer :series
      t.text :signed_xml

      t.timestamps null: false
    end
    add_foreign_key :invoices, :senders
  end
end
