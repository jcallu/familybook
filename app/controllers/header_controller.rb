class HeaderController < ApplicationController
  include FmailyHelper
  def _header
    @my_families = current_user.family_memberships.collect{|r| r.family}
  end
end
