class CreateSenders < ActiveRecord::Migration
  def change
    create_table :senders do |t|
      t.string :name
      t.string :cnpj, limit: 14
      t.string :certificate
      t.boolean :nfe_sender

      t.timestamps
    end
  end
end
