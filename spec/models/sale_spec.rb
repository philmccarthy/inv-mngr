require 'rails_helper'

RSpec.describe Sale, type: :model do
  describe 'validations' do
    it { should validate_numericality_of(:quantity).only_integer }
  end

  describe 'relationships' do
    it { should belong_to :item }
  end
end
