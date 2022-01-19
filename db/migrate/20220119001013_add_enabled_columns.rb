class AddEnabledColumns < ActiveRecord::Migration[7.0]
  def change
    add_column :items, :enabled, :boolean, default: true
    add_column :purchases, :enabled, :boolean, default: true
    add_column :sales, :enabled, :boolean, default: true
  end
end
