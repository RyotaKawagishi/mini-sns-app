require "test_helper"

class MicropostTest < ActiveSupport::TestCase

  def setup
    @user = users(:michael)
    # このコードは慣習的に正しくない
    # @micropost = Micropost.new(content: "Lorem ipsum", user_id: @user.id)
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end

  test "should be valid" do
    assert @micropost.valid?
  end

  test "user id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test "content should be present" do
    @micropost.content = "   "
    assert_not @micropost.valid?
  end

  test "content should be at most 140 characters" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end

  test "order should be most recent first" do
    assert_equal microposts(:most_recent), Micropost.first
  end

end

class Mention < ActiveSupport::TestCase

  def setup
    @user = users(:michael)
    @reply_to = users(:archer)
  end

end

class MentionTest < Mention
  
  test "should keep content unchanged if not replying" do
    micropost = Micropost.new(content: "Just a post", user: @user)
    assert micropost.valid?
  end
  
  test "should not allow replying to self" do
    micropost = Micropost.new(content: "Hello", in_reply_to: @user.id, user: @user)
    assert_not micropost.valid?
    assert_includes micropost.errors.full_messages, "In reply to You can't reply to yourself."
  end
  
end