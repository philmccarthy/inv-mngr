class CreateSales < ActiveRecord::Migration[7.0]
  def change
    create_table :sales, id: :uuid do |t|
      t.references :item, null: false, foreign_key: true, type: :uuid
      t.integer :quantity

      t.timestamps
    end
  end
end
