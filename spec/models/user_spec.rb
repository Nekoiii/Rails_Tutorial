
# RSpec describe/context/example/it/before/subject... : 
# https://zenn.dev/igaiga/books/rails-practice-note/viewer/rails_rspec_workshop
"""
require 'rails_helper'
RSpec.describe Book, type: :model do
  describe '#.メソッド名' do
    context '○○なとき' do
      it '○○なこと' do end
      it '○○なこと' do end
    end
    context '○○なとき' do
      it '○○なこと' do end
    end
  end
  describe '#.メソッド名' do ... end
end
"""

require 'rails_helper'


# 'RSpec.describe' is equals 'describe', 'RSpec.' here is just used to make it  
# clearer that it's an RSpec description block and not a regular Ruby method.
RSpec.describe User, type: :model do
  before do
    @user=User.new(
      name: 'Example User', email: 'user@example.com',
      password: 'aaaaaa', password_confirmation: 'aaaaaa'
    )
  end

  describe 'validations' do

    it 'should be valid' do
      expect(@user).to be_valid
    end

    
    context 'when name' do
      it 'gets user name' do
        expect(@user.name).to eq 'Example User'
      end

      it 'is present' do
        @user.name = '     '
        expect(@user).not_to be_valid
      end

      it 'is not too long' do
        @user.name = 'a' * 51
        expect(@user).not_to be_valid
      end
    end

    context 'when email' do
      it 'is too long' do
        @user.email = "#{'a' * 244}@example.com"
        expect(@user).not_to be_valid
      end

      it 'is valid' do
        valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
          first.last@foo.jp alice+bob@baz.cn]
        valid_addresses.each do |valid_address|
          @user.email = valid_address
          expect(@user).to be_valid
        end
      end

      it 'should be unique' do
        duplicate_user = @user.dup
        @user.save
        expect(duplicate_user).not_to be_valid
      end

      it 'should be saved as lowercase' do
        mixed_case_email = 'Foo@ExAMPle.CoM'
        @user.email = mixed_case_email
        @user.save
        # .reload: get updated data from db
        expect(@user.reload.email).to eq mixed_case_email.downcase
      end

    end


    context 'when password' do
      it 'should not be blank' do
        @user.password = @user.password_confirmation = ' ' * User::PASSWORD_LENGTH_MIN
        expect(@user).not_to be_valid  
      end

      it 'is too short' do
        @user.password = @user.password_confirmation = 'a' * (User::PASSWORD_LENGTH_MIN - 1)
        expect(@user).not_to be_valid
      end
    end
  end

  describe 'methods' do
    it 'authenticated? should return false for a user with nil digest' do
      expect(@user.authenticated?(:remember, '')).to be_falsey
    end

    it 'associated microposts should be destroyed' do
      @user.save
      @user.microposts.create!(content: 'Lorem ipsum')
      expect { @user.destroy }.to change { Micropost.count }.by(-1)
    end

    context 'when user follows and unfollows' do
      it 'another user' do
        test_user_1 = create(:test_user_3)
        test_user_2 = create(:test_user_2)
        expect(test_user_1.following?(test_user_2)).to be_falsey
        test_user_1.follow(test_user_2)
        expect(test_user_1.following?(test_user_2)).to be_truthy
        expect(test_user_2.followers).to include(test_user_1)
        test_user_1.unfollow(test_user_2)
        expect(test_user_1.following?(test_user_2)).to be_falsey
      end
    end

  end

  describe 'feeds' do
    it 'should have the right posts' do
      test_user_1 = create(:test_user_1)
      test_user_3 = create(:test_user_3)
      test_user_4 = create(:test_user_4)
      test_user_4.microposts.each do |post_following|
        expect(test_user_1.feed).to include(post_following)
      end

      test_user_3.microposts.each do |post_following|
        expect(test_user_1.feed).to include(post_following)
      end

      test_user_1.microposts.each do |post_self|
        expect(test_user_1.feed).to include(post_self)
      end

      test_user_4.microposts.each do |post_unfollowed|
        expect(test_user_1.feed).not_to include(post_unfollowed)
      end
    end
  end


end
