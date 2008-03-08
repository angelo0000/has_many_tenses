require(File.join(File.dirname(__FILE__), 'test_helper'))

class Comment < ActiveRecord::Base
  belongs_to :post
  has_many_tenses
end

class HasManyTensesTest < Test::Unit::TestCase
  
  def test_future_instance
    assert Comment.new({:created_at => 15.seconds.from_now}).future?
    assert !Comment.new({:created_at => 15.seconds.from_now}).past?
    assert !Comment.new({:created_at => 15.seconds.from_now}).recent?
  end
  
  def test_past_instance
    assert Comment.new({:created_at => 15.seconds.ago}).past?
    assert !Comment.new({:created_at => 15.seconds.ago}).future?
    assert Comment.new({:created_at => 15.seconds.ago}).recent?
  end
  
  def test_recent_instance
    assert Comment.new({:created_at => 15.seconds.ago}).recent?
    assert !Comment.new({:created_at => 15.seconds.ago}).future?
    assert Comment.new({:created_at => 15.seconds.ago}).past?
  end
  
  def test_future_has_many_association_proxy
    c = Comment.new
    post = create_posts_and_comments_with_date({:created_at => 15.seconds.from_now})
    assert_equal 5, post.comments.future.size
    assert_equal 0, post.comments.past.size
    assert_equal 0, post.comments.recent.size
  end

  def test_past_has_many_association_proxy
    post = create_posts_and_comments_with_date({:created_at => 15.minutes.ago})
    assert_equal 0, post.comments.future.size
    assert_equal 5, post.comments.past.size
    assert_equal 5, post.comments.recent.size
  end

  def test_past_and_no_recent_has_many_association_proxy
    post = create_posts_and_comments_with_date({:created_at => 15.days.ago})
    assert_equal 0, post.comments.future.size
    assert_equal 5, post.comments.past.size
    assert_equal 0, post.comments.recent.size
  end
  
end
