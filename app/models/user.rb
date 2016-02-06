class User < ApplicationRecord
  has_many :lessons
  has_many :polls, through: :lessons

  validates :email, presence: true, format: {
    with: /generalassemb\.ly\Z/,
    message: 'needs to originate from General Assembly'
  }
  
  validates :name, presence: true
  validates :image_url, presence: true
end
