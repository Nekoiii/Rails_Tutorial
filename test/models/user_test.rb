# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: 'Example User', email: 'user@example.com',
                     password: 'foobar', password_confirmation: 'foobar')
  end

  test 'should be valid' do
    assert @user.valid?
  end

  test 'name should be present' do
    @user.name = '     '
    assert_not @user.valid?
  end

  test 'name should not be too long' do
    @user.name = 'a' * 51
    assert_not @user.valid?
  end

  test 'email should not be too long' do
    @user.email = "#{'a' * 244}@example.com"
    assert_not @user.valid?
  end

  test 'email validation should accept valid addresses' do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test 'email addresses should be unique' do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test 'email addresses should be saved as lowercase' do
    mixed_case_email = 'Foo@ExAMPle.CoM'
    @user.email = mixed_case_email
    @user.save
    # .reload: get updated data from db
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test 'password should be present (nonblank)' do
    @user.password = @user.password_confirmation = ' ' * User::PASSWORD_LENGTH_MIN
    assert_not @user.valid?
  end

  test 'password should have a minimum length' do
    @user.password = @user.password_confirmation = 'a' * (User::PASSWORD_LENGTH_MIN - 1)
    assert_not @user.valid?
  end

  test 'authenticated? should return false for a user with nil digest' do
    assert_not @user.authenticated?(:remember, '')
  end

  test 'associated microposts should be destroyed' do
    @user.save
    @user.microposts.create!(content: 'Lorem ipsum')
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

  test 'should follow and unfollow a user' do
    test_user_1 = users(:test_user_3)
    test_user_2 = users(:test_user_2)
    assert_not test_user_1.following?(test_user_2)
    test_user_1.follow(test_user_2)
    assert test_user_1.following?(test_user_2)
    assert test_user_2.followers.include?(test_user_1)
    test_user_1.unfollow(test_user_2)
    assert_not test_user_1.following?(test_user_2)
    test_user_1.follow(test_user_1)
    assert_not test_user_1.following?(test_user_1)
  end

  test 'feed should have the right posts' do
    test_user_1 = users(:test_user_1)
    test_user_3 = users(:test_user_3)
    test_user_4 = users(:test_user_4)
    test_user_4.microposts.each do |post_following|
      assert test_user_1.feed.include?(post_following)
    end

    test_user_3.microposts.each do |post_following|
      assert test_user_1.feed.include?(post_following)
    end
    test_user_1.microposts.each do |post_self|
      assert test_user_1.feed.include?(post_self)
      # Check for duplicate items
      assert_equal test_user_1.feed.distinct, test_user_1.feed
    end
    test_user_4.microposts.each do |post_unfollowed|
      assert_not test_user_1.feed.include?(post_unfollowed)
    end
  end
end
