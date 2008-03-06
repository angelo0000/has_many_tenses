require 'test/unit'
require 'active_record'
require 'has_many_tenses'

ActiveRecord::Base.send(:include, RailsJitsu::HasManyTenses)

ActiveRecord::Base.establish_connection({
    'adapter' => 'sqlite3',
    'database' => ':memory:'
  })
load(File.join(File.dirname(__FILE__), 'schema.rb'))

class Post < ActiveRecord::Base
  has_many :comments, :extend => RailsJitsu::HasManyTenses::SingletonMethods
end

def create_posts_and_comments_with_date(date)
  post = Post.new({:body => "post"})
  post.save
  5.times{|i| post.comments << Comment.new(date.merge!({:body => i}))}
  post
end