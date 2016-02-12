class Choice < ApplicationRecord
  belongs_to :poll
  validates_presence_of :poll

  has_many :votes, dependent: :destroy

  validates :content, presence: true
  validates :correct, inclusion: { in: [true, false] }

  def to_html
    markdown = Redcarpet::Markdown.new(HTMLwithPygments, fenced_code_blocks: true)

    markdown.render(self.content).html_safe
  end
end
