require "test_helper"

class MicropostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @micropost = microposts(:one)
  end

  test "should get index" do
    get microposts_url, as: :json
    assert_response :success
  end

  test "should create micropost" do
    assert_difference("Micropost.count") do
      post microposts_url, params: { micropost: { content: @micropost.content, user_id: @micropost.user_id } }, as: :json
    end

    assert_response :created
  end

  test "should show micropost" do
    get micropost_url(@micropost), as: :json
    assert_response :success
  end

  test "should update micropost" do
    patch micropost_url(@micropost), params: { micropost: { content: @micropost.content, user_id: @micropost.user_id } }, as: :json
    assert_response :success
  end

  test "should destroy micropost" do
    assert_difference("Micropost.count", -1) do
      delete micropost_url(@micropost), as: :json
    end

    assert_response :no_content
  end
end
