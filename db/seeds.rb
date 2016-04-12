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

#Create Questions
100.times do
  Question.create!(
  title: RandomData.random_sentence,
  body: RandomData.random_paragraph,
  resolved: RandomData.random_boolean
  )
end

puts "Seeds finished."
puts "#{Post.count} posts created"
puts "#{Comment.count} comments created"
puts "#{Question.count} questions created"
