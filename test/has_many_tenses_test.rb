require 'test_helper'

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
    post = create_posts_and_comments_with_date(15.seconds.from_now)
    assert_equal post.comments.future.size, 5
    assert_equal post.comments.past.size, 0
    assert_equal post.comments.recent.size, 0
  end

  def test_past_has_many_association_proxy
    post = create_posts_and_comments_with_date(15.seconds.ago)
    assert_equal post.comments.future.size, 0
    assert_equal post.comments.past.size, 5
    assert_equal post.comments.recent.size, 5
  end

  def test_past_and_no_recent_has_many_association_proxy
    post = create_posts_and_comments_with_date(15.days.ago)
    assert_equal post.comments.future.size, 0
    assert_equal post.comments.past.size, 5
    assert_equal post.comments.recent.size, 0
  end
end
