# frozen_string_literal: true

require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = users(:test_user_1)
    # Although this code is also correct, it is not customary to write it like this:
    # @micropost = Micropost.new(content: "Lorem ipsum", user_id: @user.id)
    @micropost = @user.microposts.build(content: 'Lorem ipsum')
  end

  test 'should be valid' do
    assert @micropost.valid?
  end

  test 'user id should be present' do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test 'content should be present' do
    @micropost.content = '   '
    assert_not @micropost.valid?
  end

  test 'content should be at most CONTENT_LENTH_MAX characters' do
    @micropost.content = 'a' * (Micropost::CONTENT_LENTH_MAX + 1)
    assert_not @micropost.valid?
  end

  test 'order should be most recent first' do
    assert_equal microposts(:most_recent_micropost), Micropost.first
  end
end
