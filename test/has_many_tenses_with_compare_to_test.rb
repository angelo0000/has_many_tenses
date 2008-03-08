require(File.join(File.dirname(__FILE__), 'test_helper'))

class SecondComment < ActiveRecord::Base
  belongs_to :post
  has_many_tenses :compare_to => :date
end

class HasManyTensesWithCompareToTest < Test::Unit::TestCase
  
  def test_future_instance
    assert SecondComment.new({:date => 15.seconds.from_now}).future?
    assert !SecondComment.new({:date => 15.seconds.from_now}).past?
    assert !SecondComment.new({:date => 15.seconds.from_now}).recent?
  end
  
  def test_past_instance
    assert SecondComment.new({:date => 15.seconds.ago}).past?
    assert !SecondComment.new({:date => 15.seconds.ago}).future?
    assert SecondComment.new({:date => 15.seconds.ago}).recent?
  end
  
  def test_recent_instance
    assert SecondComment.new({:date => 15.seconds.ago}).recent?
    assert !SecondComment.new({:date => 15.seconds.ago}).future?
    assert SecondComment.new({:date => 15.seconds.ago}).past?
  end
  
  def test_future_has_many_association_proxy
    post = create_posts_and_second_comments_with_date({:date => 15.seconds.from_now})
    assert_equal 5, post.second_comments.future.size
    assert_equal 0, post.second_comments.past.size
    assert_equal 0, post.second_comments.recent.size
  end

  def test_past_has_many_association_proxy
    post = create_posts_and_second_comments_with_date({:date => 15.seconds.ago})
    assert_equal 0, post.second_comments.future.size
    assert_equal 5, post.second_comments.past.size
    assert_equal 5, post.second_comments.recent.size
  end

  def test_past_and_no_recent_has_many_association_proxy
    post = create_posts_and_second_comments_with_date({:date => 15.days.ago})
    assert_equal 0, post.second_comments.future.size
    assert_equal 5, post.second_comments.past.size
    assert_equal 0, post.second_comments.recent.size
  end
  
end
