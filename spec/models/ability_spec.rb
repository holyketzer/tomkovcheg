require 'spec_helper'

shared_examples_for 'guest' do
  #it { should_not be_able_to :manage, :all }
  #it { should_not be_able_to :read, :all }

  it { should be_able_to :read, Article }
end

shared_examples_for 'user' do
  #it { should be_able_to :create, Bid }
  it { should be_able_to :manage, :account }
end

shared_examples_for 'moderator' do
  it_behaves_like 'user'

  it { should be_able_to :manage, Article }
end

describe Ability do
  # Initialize abilities
  before(:all) { Tomkovcheg::Application.load_seed }

  subject(:ability) { Ability.new(user) }

  describe 'admin' do
    let(:user) { create(:admin) }

    it { should be_able_to :manage, :all }
  end

  describe 'moderator' do
    let(:user) { create(:moderator) }

    it_behaves_like 'moderator'
  end

  describe 'user' do
    let(:user) { create(:user) }

    it_behaves_like 'guest'
    it_behaves_like 'user'
  end

  describe 'guest' do
    let(:user) { nil }

    it_behaves_like 'guest'
  end
end