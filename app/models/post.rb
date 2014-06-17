class Post < ActiveRecord::Base

  belongs_to :user
  has_many :comments

  validate :content, presence: true

  acts_as_likeable

  has_attached_file :avatar, :styles => {:original => "400x", :thumb => "80x80!"},
    :source_file_options => { :all => '-auto-orient'},
    :storage => :dropbox,
    :dropbox_credentials => Rails.root.join("config/dropbox.yml"),
    :path => "/avatars/posts_:id_:style_:filename"

  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  
  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }
end
