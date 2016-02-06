class Poll < ApplicationRecord
  belongs_to :lesson

  has_many :choices, inverse_of: :poll
  has_many :votes, through: :choices

  accepts_nested_attributes_for :choices,
    reject_if: proc { |c| c[:content].blank? }

  validates :choices, length: { minimum: 1, message: "(at least 1) must be present" }
  validates :question, presence: true
  validates :active, inclusion: { in: [true, false] }

  def to_html
    markdown = Redcarpet::Markdown.new(HTMLwithPygments, fenced_code_blocks: true)

    markdown.render(self.question).html_safe
  end

  def choices_with_count
    poll = Poll.includes(choices: :votes)
            .find(self.id)

    vote_count = poll.votes.count

    poll.choices.map do |choice|
      {
        choice: choice,
        votes:  choice.votes.count,
        vote_percent: (choice.votes.count * 100.0 / vote_count).round(2)
      }
    end
  end
end
