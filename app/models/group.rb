class Group < ActiveRecord::Base
  has_many :group_memberships
  has_many :group_membership_requests
  has_many :users, :through => :group_memberships
  def to_param
    short_name
  end
end
