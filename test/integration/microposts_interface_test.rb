require "test_helper"

class MicropostsInterface < ActionDispatch::IntegrationTest

  def setup
    @user = users(:test_user_1)
    log_in_as(@user)
  end
end

class MicropostsInterfaceTest < MicropostsInterface

  test "should paginate microposts" do
    get root_path
    assert_select 'div.pagination'
  end

  test "should display the right micropost count" do
    get root_path
    assert_match "#{@user.microposts.count} microposts", response.body
  end

  test "should user proper pluralization for one micropost" do
    log_in_as(users(:test_user_1))
    get root_path
    assert_match '1 micropost', response.body
  end

  test "should show errors but not create micropost on invalid submission" do
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "" } }
    end
    assert_select 'div#error_explanation'
    assert_select 'a[href=?]', '/?page=2'  # 正しいページネーションリンク
  end

  test "should create a micropost on valid submission" do
    content = "This micropost really ties the room together"
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { content: content } }
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
  end

  test "should have micropost delete links on own profile page" do
    get user_path(@user)
    assert_select 'a', text: 'delete'
  end

  test "should be able to delete own micropost" do
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
  end

  test "should not have delete links on other user's profile page" do
    get user_path(users(:test_user_2))
    assert_select 'a', { text: 'delete', count: 0 }
  end
end

class ImageUploadTest < MicropostsInterface

  test "should have a file input field for images" do
    get root_path
    assert_select 'input[type=file]'
  end

  test "should be able to attach an image" do
    cont = "This micropost really ties the room together."
    img  = fixture_file_upload('doggy.png', 'image/png')
    post microposts_path, params: { micropost: { content: cont, image: img } }
    assert @user.microposts.first.image.attached?
  end
end



