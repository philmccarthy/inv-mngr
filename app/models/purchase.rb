class Purchase < ApplicationRecord
  validates_numericality_of :quantity, { only_integer: true }

  belongs_to :item, dependent: :destroy
end
