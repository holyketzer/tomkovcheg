require 'spec_helper'

describe Category do
  describe "validations" do
    it { should validate_presence_of :title }
    it { should validate_presence_of :priority }
    it { should validate_uniqueness_of(:title).case_insensitive }
  end

  describe "associations" do
    it { should have_many(:articles) }
    it { should have_many(:images) }
  end
end
