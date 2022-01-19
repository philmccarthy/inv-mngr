require 'rails_helper'

RSpec.describe 'Items System Spec', type: :system do
  before do
    driven_by(:rack_test)
  end

  describe 'Items index page' do
    before do
      @item_one = Item.create(name: 'Item 1', description: 'Example item', category: 'Soft Goods', initial_stock: 10)
      @item_one.purchases.create(quantity: 5)
      @item_one.purchases.create(quantity: 10)
      @item_one.sales.create(quantity: 4)

      @item_two = Item.create(name: 'Item 2', description: 'Example item', category: 'Hard Goods', initial_stock: 2)
      @item_two.purchases.create(quantity: 12)
      @item_two.purchases.create(quantity: 20)
      @item_two.sales.create(quantity: 4)

      @item_three = Item.create(name: 'Item 3', description: 'Example item', category: 'Soft Goods', initial_stock: 5)
      @item_three.purchases.create(quantity: 14)
      @item_three.purchases.create(quantity: 17)
      @item_three.sales.create(quantity: 4)
      @item_three.sales.create(quantity: 8)
    end

    it 'displays all items with dynamic data' do
      visit items_path

      within('#items') do
        expect(page).to have_text('Item 1')
        expect(page).to have_text('Item 2')
        expect(page).to have_text('Item 3')
        expect(page).to have_button('New Item')
      end

      Item.all.each do |item|
        within("#item-#{item.id}") do
          expect(page).to have_text("Description: #{item.description}")
          expect(page).to have_text("Category: #{item.category}")
          expect(page).to have_text("Initial Amount in Inventory: #{item.initial_stock}")
          expect(page).to have_text("Current Amount in Inventory: #{item.current_stock}")
          item.purchases.each do |purchase|
            expect(page).to have_link("Purchase of #{purchase.quantity} units")
          end
          item.sales.each do |sale|
            expect(page).to have_link("Sale of #{sale.quantity} units")
          end
        end
      end
    end
  end

  describe 'Creates a new item' do
    it 'allows an item to be created when valid' do
      visit new_item_path

      within('#form') do
        fill_in :item_name, with: 'Test Item'
        fill_in :item_description, with: 'This is a description'
        fill_in :item_category, with: 'Example Category'
        fill_in :item_initial_stock, with: '50'
        click_button 'Create Item'
      end

      expect(current_path).to eq(items_path)

      within('#flash-message') do
        expect(page).to have_text('Item was added successfully')
      end
    end

    it 'displays errors and re-renders :new with errors when invalid' do
      visit new_item_path

      within('#form') do
        fill_in :item_name, with: 'Test Item'
        fill_in :item_description, with: 'This is a description'
        fill_in :item_initial_stock, with: '-1'
        click_button 'Create Item'
      end

      expect(current_path).to eq(new_item_path)

      within('#flash-message') do
        expect(page).to have_text("Category can't be blank")
        expect(page).to have_text('Initial stock must be greater than or equal to 0')
      end
    end
  end

  describe 'Updates an existing item' do
    before do
      @item = Item.create(name: 'Item 1', description: 'Example item', category: 'Soft Goods', initial_stock: 10)
    end
    it 'allows an item to be updated' do
      visit edit_item_path(@item)

      within('#form') do
        fill_in :item_name, with: 'Updated Name'
        fill_in :item_description, with: 'This is a new description'
        fill_in :item_category, with: 'New Category'
        fill_in :item_initial_stock, with: '15'
        click_button 'Update Item'
      end

      expect(current_path).to eq(items_path)

      within('#flash-message') do
        expect(page).to have_text('Item successfully updated')
      end

      within("#item-#{@item.id}") do
        expect(page).to have_text('Updated Name')
        expect(page).to have_text('This is a new description')
        expect(page).to have_text('New Category')
        expect(page).to have_text('15')
      end
    end

    it 'shows error messages when validations fail on update' do
      visit edit_item_path(@item)

      within('#form') do
        fill_in :item_name, with: ''
        fill_in :item_description, with: ''
        fill_in :item_category, with: ''
        fill_in :item_initial_stock, with: '-10'
        click_button 'Update Item'
      end

      expect(current_path).to eq(edit_item_path(@item))

      within('#flash-message') do
        expect(page).to have_text("Name can't be blank")
        expect(page).to have_text("Description can't be blank")
        expect(page).to have_text("Category can't be blank")
        expect(page).to have_text('Initial stock must be greater than or equal to 0')
      end
    end
  end

  describe 'Item delete disables an item' do
    before do
      @item = Item.create(name: 'Item 1', description: 'Example item', category: 'Soft Goods', initial_stock: 10)
    end

    it 'Deletes an existing item successfully' do
      visit items_path

      expect(page).to have_text('Item 1')

      within("#item-#{@item.id}") do
        click_button 'Delete'
      end

      within('#flash-message') do
        expect(page).to have_text('Item was deleted successfully.')
      end

      within('#items') do
        expect(page).to have_text('Item 1 was deleted.')
      end
    end

    it 'Undeleted a disabled item successfully' do
      @item.update(enabled: false)
      visit items_path

      within("#item-#{@item.id}") do
        expect(page).to have_text("#{@item.name} was deleted.")
        expect(page).to_not have_text(@item.description)
        expect(page).to_not have_text(@item.category)
        click_button 'Undelete This Item'
      end

      expect(current_path).to eq(items_path)

      within("#item-#{@item.id}") do
        expect(page).to_not have_text 'This item was deleted.'
        expect(page).to_not have_button 'Undelete This Item'
        expect(page).to have_text(@item.description)
        expect(page).to have_text(@item.category)
      end
    end
  end
end
