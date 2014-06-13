class Family < ActiveRecord::Base
  has_many :family_memberships
  has_many :users, :through => :family_memberships
  def to_param
    short_name
  end
end
