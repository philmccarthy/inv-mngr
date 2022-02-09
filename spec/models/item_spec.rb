require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :category }
    it { should validate_numericality_of(:initial_stock).only_integer }
    it { should validate_numericality_of(:initial_stock).is_greater_than_or_equal_to(0) }
  end

  describe 'relationships' do
    it { should have_many :sales }
    it { should have_many :purchases }
  end

  describe 'class methods' do
    it '::all_with_current_stock' do
      item = Item.create(name: 'Item 1', description: 'Example item', category: 'Soft Goods', initial_stock: 10)
      purch = item.purchases.create(quantity: 5)
      sale = item.sales.create(quantity: 10)

      query_item = Item.all_with_current_stock.first

      expect(query_item.current_stock).to eq(5)
      expect(query_item.qty_purchased).to eq(5)
      expect(query_item.qty_sold).to eq(10)
      expect(query_item.purchases).to eq([purch])
      expect(query_item.sales).to eq([sale])
    end
  end
end
