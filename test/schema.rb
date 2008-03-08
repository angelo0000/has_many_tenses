ActiveRecord::Schema.define(:version => 0) do

  create_table :posts, :force => true do |t|
    t.string        :title
    t.text          :body
    t.timestamps
  end

  create_table :comments, :force => true do |t|
    t.references        :post
    t.timestamps
    t.text              :body
    t.time              :date
  end

  create_table :second_comments, :force => true do |t|
    t.references        :post
    t.timestamps
    t.text              :body
    t.time              :date
  end

  create_table :third_comments, :force => true do |t|
    t.references        :post
    t.timestamps
    t.text              :body
    t.time              :date
  end

end
