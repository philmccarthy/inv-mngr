require 'rails_helper'

RSpec.describe 'Purchases System Spec', type: :system do
  before do
    driven_by(:rack_test)
  end
  describe 'Purchase show page' do
    it 'shows purchase details' do
      item = Item.create(name: 'Item 1', description: 'Example item', category: 'Soft Goods', initial_stock: 10)
      purchase = item.purchases.create(quantity: 10)

      visit item_purchase_path(item, purchase)

      expect(page).to have_text "Item Purchased: #{item.name}"
      expect(page).to have_text "Quantity Purchased: #{purchase.quantity}"
    end
  end
end
