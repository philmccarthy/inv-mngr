require 'rails_helper'

RSpec.describe 'Sales System Spec', type: :system do
  before do
    driven_by(:rack_test)
  end

  describe 'Sale show page' do
    it 'shows sale details' do
      item = Item.create(name: 'Item 1', description: 'Example item', category: 'Soft Goods', initial_stock: 10)
      sale = item.sales.create(quantity: 5)

      visit item_sale_path(item, sale)

      expect(page).to have_text "Item Sold: #{item.name}"
      expect(page).to have_text "Quantity Sold: #{sale.quantity}"
    end
  end
end
