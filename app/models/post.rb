class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  validate :content, presence: true
  acts_as_likeable

  has_attached_file :avatar, :styles => {:original => "400x400!", :thumb => "100x100!" },   
    :default_url => "/system/posts/:style/missing.png",
    :url  => "/system/posts/:id/:style_:filename",
    :path => ":rails_root/public/system/posts/:id/:style_:filename",
    :source_file_options => { :all => '-auto-orient'}
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }
end
