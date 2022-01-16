# frozen_string_literal: true

class Item < ApplicationRecord
  validates :name, :description, :category, presence: true
  validates_numericality_of :initial_stock, { only_integer: true, greater_than_or_equal_to: 0 }
end
