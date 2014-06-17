class HeaderController < ApplicationController
  
  before_filter :authenticate_user!

  include GroupHelper

  def _header
    @my_groups = current_user.group_memberships.collect{|r| r.group}
    @group = current_group
    @requests = GroupMembershiRequest.find_by_group_id(@group.id)
  end
end
