class FamiliesController < ApplicationController
  def new
    @family = Family.new
  end

  def create
    @family = Family.new(family_params)
    @family.owner_id = @family.admin_id = current_user.id
    @family.short_name = family_params['name'].gsub(" ","_").downcase
    @family.save
    
    @family_membership = FamilyMembership.new
    @family_membership.user_id = current_user.id
    @family_membership.family_id = @family.id
    @family_membership.save

    redirect_to families_path
  end 
  
  def index
    redirect_to new_family_path if current_user.family_memberships.empty?

  end

  private

  def family_params
    params.require(:family).permit(:name,:id)
  end

end
