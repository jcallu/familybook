class FamiliesController < ApplicationController
  def new
    @family = Family.new
  end

  def create
    @family = Family.new(family_params)
    @family.owner_id = @family.admin_id = current_user.id
    @family.short_name = family_params['name'].gsub(" ","_").downcase
    @family_membership = FamilyMembership.new
    @family_membership.user_id = current_user.id
    @family_membership.family_id = @family.id
    respond_to do |format|
      if @family_membership.save && @family.save
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

  private

  def family_params
    params.require(:family).permit(:name,:id)
  end

end
