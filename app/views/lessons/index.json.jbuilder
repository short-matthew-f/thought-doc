json.lessons(@lessons.order(created_at: :desc)) do |lesson|
  json.id         lesson.id
  json.title      lesson.title
  json.githubUrl  lesson.github_url
  json.lessonUrl  root_url + "students/" + lesson.token

  json.polls(lesson.polls.order(:created_at)) do |poll|
    json.id         poll.id
    json.question   poll.to_html
    json.active     poll.active
    json.totalVotes poll.votes.count

    json.choices(poll.choices) do |choice|
      json.id         choice.id
      json.content    choice.to_html
      json.correct    choice.correct
      json.totalVotes choice.votes.count
    end
  end
end
