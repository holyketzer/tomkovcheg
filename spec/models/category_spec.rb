require 'spec_helper'

describe Category do
  describe "validations" do
    it { should validate_presence_of :title }
    it { should validate_presence_of :priority }
    it { should validate_uniqueness_of(:title).case_insensitive }
  end

  describe "associations" do
  end
end
