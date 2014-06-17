class GroupMembership < ActiveRecord::Base
  belongs_to :group
  belongs_to :user
  has_many :user_default_group, :through => :group_memberships, :source => :user
end
