require 'spec_helper'

describe User do
  describe 'validations' do
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of(:email).case_insensitive }

    it { should validate_presence_of :nickname }
    it { should validate_uniqueness_of(:nickname).case_insensitive }

    it { should validate_presence_of :password }
  end

  describe "associations" do
    it { should have_one(:avatar) }
  end
end
