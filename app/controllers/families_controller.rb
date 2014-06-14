class FamiliesController < ApplicationController
  before_action :set_family, only: [:show]

  def new
    @family = Family.new
  end

  def create
    @family = Family.new(family_params)
    @family.owner_id = @family.admin_id = current_user.id
    @family.short_name = family_params['name'].gsub(" ","_").downcase
    @saved1 = @family.save
    @family_membership = FamilyMembership.new
    @family_membership.user_id = current_user.id
    @family_membership.family_id = @family.id
    @saved2 = @family_membership.save
    respond_to do |format|
      if @saved1 && @saved2
        format.html { redirect_to families_path, notice: 'Family was successfully created.' }
        format.json { render :index, status: :ok, location: families_path }
      else
        format.html { render :edit }
        format.json { render json: @family.errors, status: :unprocessable_entity }
      end
    end
  end

  def index
    @family = Family.new
    @families = Family.all
    @my_families = current_user.family_memberships.collect{|r| r.family}
  end

  def show
    @this_family = Family.find_by_short_name(set_family)
  end

  def request_family_membership
    @family = Family.find(params[:id])
    @family_requested = FamilyMembershipRequest.new
    @family_requested.requested_user_id = current_user.id
    @family_requested.family_id = @family.id
    redirect_to @family
  end
  private

  def family_params
    params.require(:family).permit(:name,:short_name,:user_id, :family)
  end

  def set_family
    params.require(:id)
  end
end
