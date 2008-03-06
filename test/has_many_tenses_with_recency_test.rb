require(File.join(File.dirname(__FILE__), 'test_helper'))

class Comment < ActiveRecord::Base
  belongs_to :post
  has_many_tenses :recency => 15.days.ago
end

class HasManyTensesWithRecencyTest < Test::Unit::TestCase
  
  def test_recent_instance
    assert Comment.new({:created_at => 15.days.ago}).recent?
    assert !Comment.new({:created_at => 15.days.ago}).future?
    assert Comment.new({:created_at => 15.days.ago}).past?
  end
  
  def test_recent_has_many_association_proxy
    post = create_posts_and_comments_with_date({:created_at => 15.days.ago})
    assert_equal 0, post.comments.future.size
    assert_equal 5, post.comments.past.size
    assert_equal 5, post.comments.recent.size
  end

  def test_past_and_no_recent_has_many_association_proxy
    post = create_posts_and_comments_with_date({:created_at => 16.days.ago})
    assert_equal 0, post.comments.future.size
    assert_equal 5, post.comments.past.size
    assert_equal 0, post.comments.recent.size
  end
 
end