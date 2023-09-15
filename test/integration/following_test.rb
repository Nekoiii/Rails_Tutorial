# frozen_string_literal: true

require 'test_helper'

class Following < ActionDispatch::IntegrationTest
  def setup
    @user  = users(:test_user_1)
    @other = users(:test_user_2)
    log_in_as(@user)
  end
end

class FollowPagesTest < Following
  test 'following page' do
    get following_user_path(@user)
    assert_response :unprocessable_entity
    assert_not @user.following.empty?
    assert_match @user.following.count.to_s, response.body
    @user.following.each do |user|
      assert_select 'a[href=?]', user_path(user)
    end
  end

  test 'followers page' do
    get followers_user_path(@user)
    assert_response :unprocessable_entity
    assert_not @user.followers.empty?
    assert_match @user.followers.count.to_s, response.body
    @user.followers.each do |user|
      assert_select 'a[href=?]', user_path(user)
    end
  end

  test 'feed on Home page' do
    get root_path
    @user.feed.paginate(page: 1).each do |micropost|
      assert_match CGI.escapeHTML(micropost.content), response.body
    end
  end
end
