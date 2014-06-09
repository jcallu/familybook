require 'open-uri'
class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :name, presence: true

  has_many :posts
  has_many :comments
  
  acts_as_follower
  acts_as_followable
  acts_as_likeable
  acts_as_liker

  has_attached_file :avatar, :styles => {:original => "200x200!", :thumb => "80x80!" },
    :source_file_options => { :all => '-auto-orient'},
    :default_url => "/missing.png",
    :storage => :dropbox,
    :dropbox_credentials => Rails.root.join("config/dropbox.yml"),
    :path => "/avatars/users_:id_:style_:filename"

  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
end
