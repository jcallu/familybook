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
  has_attached_file :avatar, :styles => {:original => "400x400!", :thumb => "100x100!" },   
    :default_url => "/system/avatars/:style/missing.png",
    :url  => "/system/avatars/:id/:style_:filename",
    :path => ":rails_root/public/system/avatars/:id/:style_:filename",
    :source_file_options => { :all => '-auto-orient'}
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
end
