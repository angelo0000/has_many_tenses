require(File.join(File.dirname(__FILE__), 'test_helper'))

class ThirdComment < ActiveRecord::Base
  belongs_to :post
  has_many_tenses :recency => 15.days.ago
end

class HasManyTensesWithRecencyTest < Test::Unit::TestCase
  
  def test_recent_instance
    assert ThirdComment.new({:created_at => 15.days.ago}).recent?
    assert !ThirdComment.new({:created_at => 15.days.ago}).future?
    assert ThirdComment.new({:created_at => 15.days.ago}).past?
  end
  
  def test_recent_has_many_association_proxy
    post = create_posts_and_third_comments_with_date({:created_at => 15.days.ago})
    assert_equal 0, post.third_comments.future.size
    assert_equal 5, post.third_comments.past.size
    assert_equal 5, post.third_comments.recent.size
  end

  def test_past_and_no_recent_has_many_association_proxy
    post = create_posts_and_third_comments_with_date({:created_at => 16.days.ago})
    assert_equal 0, post.third_comments.future.size
    assert_equal 5, post.third_comments.past.size
    assert_equal 0, post.third_comments.recent.size
  end
 
end