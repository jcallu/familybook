class FamilyMembership < ActiveRecord::Base
  belongs_to :family
  belongs_to :user
  has_many :user_default_family, :through => :family_memberships, :source => :user
end
