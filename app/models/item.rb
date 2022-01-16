class Item < ApplicationRecord
  validates :name, :description, presence: true
end
