class HeaderController < ApplicationController
  
  before_filter :authenticate_user!

  include FamilyHelper

  def _header
    @my_families = current_user.family_memberships.collect{|r| r.family}
    @family = current_family
    @requests = FamilyMembershiRequest.find_by_family_id(@family.id)
  end
end
