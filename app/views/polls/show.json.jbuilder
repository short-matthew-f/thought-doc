json.id         @poll.id
json.question   @poll.to_html
json.active     @poll.active
json.totalVotes @poll.votes.count

json.choices(@poll.choices) do |choice|
  json.id         choice.id
  json.content    choice.to_html
  json.correct    choice.correct
  json.totalVotes choice.votes.count
end
