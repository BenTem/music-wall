class User < ActiveRecord::Base
  has_many :songs
  has_many :songs, through: :songs_users
end