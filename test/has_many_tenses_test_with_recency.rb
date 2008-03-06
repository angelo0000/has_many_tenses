require 'test_helper'

class Comment < ActiveRecord::Base
  belongs_to :post
  has_many_tenses :recency => 15.days.ago
end

class HasManyTensesTestWithRecency < Test::Unit::TestCase
  
  def test_recent_instance
    assert Comment.new({:created_at => 15.days.ago}).recent?
    assert !Comment.new({:created_at => 15.days.ago}).future?
    assert Comment.new({:created_at => 15.days.ago}).past?
  end
  
  def test_recent_has_many_association_proxy
    post = create_posts_and_comments_with_date(15.days.ago)
    assert_equal post.comments.future.size, 0
    assert_equal post.comments.past.size, 5
    assert_equal post.comments.recent.size, 5
  end

  def test_past_and_no_recent_has_many_association_proxy
    post = create_posts_and_comments_with_date(16.days.ago)
    assert_equal post.comments.future.size, 0
    assert_equal post.comments.past.size, 5
    assert_equal post.comments.recent.size, 0
  end
  
end