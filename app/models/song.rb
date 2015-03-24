class Song < ActiveRecord::Base
  belongs_to :user
  has_many :users, through: :songs_users

  validates :author, presence: true, length: { maximum: 140 }
  validates :song_title, presence: true, length: { maximum: 140 }
end