require 'spec_helper'

describe User do
  describe 'validations' do
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of(:email).case_insensitive }

    it { should validate_presence_of :nickname }
    it { should validate_uniqueness_of(:nickname).case_insensitive }

    it { should validate_presence_of :password }
  end

  describe 'associations' do
    it { should have_one(:avatar) }
    it { should have_many(:authentications) }
  end

  describe 'OmniAuth authentications' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'vkontakte', uid: '123456') }

    describe '.find_by_oauth' do
      context 'user already has authentication' do
        it 'returns user' do
          user.authentications.create(provider: 'vkontakte', uid: '123456')
          expect(User.find_by_oauth(auth)).to eq user
        end
      end

      context 'user has not authentication' do
        context 'user already registered' do
          let(:auth) { OmniAuth::AuthHash.new(provider: 'vkontakte', uid: '123456', info: { email: user.email }) }

          it 'does not create new user' do
            expect { User.find_by_oauth(auth) }.to_not change(User, :count)
          end

          it 'creates authentication for user' do
            expect { User.find_by_oauth(auth) }.to change(user.authentications, :count).by(1)
          end

          it 'creates authentication with provider and uid' do
            user = User.find_by_oauth(auth)
            authentication = user.authentications.first
            expect(authentication.provider).to eq auth.provider
            expect(authentication.uid).to eq auth.uid
          end

          it 'returns user' do
            expect(User.find_by_oauth(auth)).to eq user
          end
        end

        context 'user not registered' do
          let(:new_user) { build(:user) }
          let(:auth) { OmniAuth::AuthHash.new(provider: 'vkontakte', uid: '123456', info: { email: new_user.email, nickname: new_user.nickname }) }

          it 'creates new user' do
            expect { User.find_by_oauth(auth) }.to change(User, :count).by(1)
          end

          it 'fills user email' do
            user = User.find_by_oauth(auth)
            expect(user.email).to eq new_user.email
          end

          it 'creates authentication for user' do
            user = User.find_by_oauth(auth)

            expect(user.authentications).to_not be_empty
          end

          it 'creates authentication with provider and uid' do
            authentication = User.find_by_oauth(auth).authentications.first

            expect(authentication.provider).to eq auth.provider
            expect(authentication.uid).to eq auth.uid
          end
        end

        context "OAuth provider doesn't return email" do
          let(:auth) { OmniAuth::AuthHash.new(provider: 'vkontakte', uid: '123456', info: { }) }

          it 'does not create new user' do
            expect { User.find_by_oauth(auth) }.to_not change(User, :count)
          end

          it 'returns nil' do
            expect(User.find_by_oauth(auth)).to be_nil
          end
        end
      end
    end

    describe '#add_authentication' do
      context 'authentication does not exist' do
        it 'adds authentication to user' do
          expect { user.add_authentication(auth) }.to change(user.authentications, :count).by(1)
        end

        it 'returns true' do
          expect(user.add_authentication(auth)).to be_true
        end
      end

      context 'authentication already exists' do
        context 'authentication is associated with current user' do
          before { user.create_authentication(auth) }

          it 'does not add authentication' do
            expect { user.add_authentication(auth) }.to_not change(user.authentications, :count)
          end

          it 'returns true' do
            expect(user.add_authentication(auth)).to be_true
          end
        end
      end

      context 'authentication associated with other user' do
        let(:other) { create(:user) }
        before { other.create_authentication(auth) }

        it 'does not add authentication' do
          expect { user.add_authentication(auth) }.to_not change(user.authentications, :count)
        end

        it 'returns false' do
          expect(user.add_authentication(auth)).to be_false
        end
      end
    end
  end
end
