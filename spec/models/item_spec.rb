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
end
