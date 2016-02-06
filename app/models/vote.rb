class Vote < ApplicationRecord
  belongs_to :choice
  delegate :poll, to: :choice

  validate :has_not_voted_on_poll

  def has_not_voted_on_poll
    my_poll = Poll.includes(choices: :votes)
                .find(self.poll.id)


    if my_poll.votes.any? { |v| v.token == self.token }
      errors.add(:vote, "can not be for a poll you have already voted on")
    end
  end
end
