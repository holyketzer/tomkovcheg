require 'spec_helper'

describe Gallery do
  describe 'validations' do
    it { should validate_presence_of :title }
  end

  describe 'associations' do
    it { should have_many(:images) }
  end
end
