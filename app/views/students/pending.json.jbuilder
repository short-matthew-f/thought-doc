json.lesson do
  json.title     @lesson.title
  json.githubUrl @lesson.github_url
end

json.polls @pending_polls do |poll|
  json.id       poll.id
  json.question poll.to_html
  json.choices  poll.choices do |choice|
    json.id       choice.id
    json.content  choice.to_html
  end
end
