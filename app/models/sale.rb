class Sale < ApplicationRecord
  validates_numericality_of :quantity, { only_integer: true }

  belongs_to :item
end
