require 'spec_helper'

describe Article do
  describe 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
  end

  describe 'associations' do
    it { should belong_to(:category) }
    it { should have_many(:images) }
    it { should have_many(:comments) }
  end
end
