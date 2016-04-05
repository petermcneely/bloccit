require 'random_data'

#Create Posts
50.times do
  Post.create!(
    title: RandomData.random_sentence,
    body: RandomData.random_paragraph
    )
end
post = Post.all

#Create Comments
100.times do
  Comment.create!(
  post: post.sample,
  body: RandomData.random_paragraph
  )
end

post = Post.find_or_create_by(title: "Idempotence Post", body: "Here is my post about idempotence.")
Comment.find_or_create_by(post: post, body: "Here is my comment about idempotence.")

puts "Seeds finished."
puts "#{Post.count} posts created"
puts "#{Comment.count} comments created"
