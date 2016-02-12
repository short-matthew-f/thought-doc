class Lesson < ApplicationRecord
  before_save :ensure_presence_of_token

  belongs_to :user
  has_many   :polls, dependent: :destroy

  validates :title, presence: true
  validates :github_url, allow_blank: true, format: {
    with: /github.com/,
    message: 'should point to github repo for lesson'
  }

  private

  def ensure_presence_of_token
    self.token ||= SecureRandom.urlsafe_base64
  end
end
