# frozen_string_literal: true

class Item < ApplicationRecord
  validates :name, :description, :category, presence: true
  validates_numericality_of :initial_stock, {
    only_integer: true,
    greater_than_or_equal_to: 0
  }

  has_many :sales
  has_many :purchases

  def self.order_by_created_at
    order(:created_at).includes(:purchases, :sales)
  end

  def current_stock
    initial_stock + purchases.map(&:quantity).sum - sales.map(&:quantity).sum
  end
end
