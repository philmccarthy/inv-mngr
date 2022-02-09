class Item < ApplicationRecord
  validates :name, :description, :category, presence: true
  validates_numericality_of :initial_stock, {
    only_integer: true,
    greater_than_or_equal_to: 0
  }

  has_many :sales
  has_many :purchases

  def self.all_with_current_stock
    select('items.*,
            COALESCE(p.qty_purchased, 0) AS qty_purchased,
            COALESCE(s.qty_sold, 0) AS qty_sold,
            items.initial_stock + Coalesce(p.qty_purchased, 0) - Coalesce(s.qty_sold, 0) AS current_stock')
    .joins('LEFT JOIN (SELECT item_id, sum(quantity) AS qty_purchased FROM purchases
            GROUP BY item_id) AS p ON items.id = p.item_id')
    .joins('LEFT JOIN (SELECT item_id, sum(quantity) AS qty_sold FROM sales
            GROUP BY item_id) AS s ON items.id = s.item_id')
    .order(enabled: :desc, created_at: :desc)
    .includes(:purchases, :sales)
  end
end
