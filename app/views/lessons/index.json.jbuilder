json.lessons(@lessons) do |lesson|
  json.id         lesson.id
  json.title      lesson.title
  json.githubUrl  lesson.github_url
  json.lessonUrl  root_url + "students/" + lesson.token

  json.polls(lesson.polls) do |poll|
    json.id       poll.id
    json.question poll.to_html
    json.active   poll.active

    json.choices(poll.choices) do |choice|
      json.id       choice.id
      json.content  choice.to_html
      json.correct  choice.correct
    end
  end
end
