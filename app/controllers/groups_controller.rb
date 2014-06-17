class GroupsController < ApplicationController

  before_filter :authenticate_user!

  before_action :set_group, only: [:show]

  include GroupHelper

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.owner_id = @group.admin_id = current_user.id
    @group.short_name = group_params['name'].gsub(" ","_").downcase
    @saved1 = @group.save
    @group_membership = GroupMembership.new
    @group_membership.user_id = current_user.id
    @group_membership.group_id = @group.id
    @saved2 = @group_membership.save

    respond_to do |format|
      if @saved1 && @saved2
        format.html { redirect_to groups_path, notice: 'Group was successfully created.' }
        format.json { render :index, status: :ok, location: groups_path }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  def index
    unless user_signed_in?
      redirect_to new_user_session_path
    else
      @group = Group.new
      @groups = Group.all
      @my_groups = current_user.group_memberships.collect{|r| r.group}
    end
  end

  def show
    @group = Group.find_by_short_name(set_group)
  end

  def group_request_sent
    @group = Group.find(params[:group])
    if current_user.group_membership_requests.where(:group_id => params[:group]).empty?
      group_requested = GroupMembershipRequest.new
      group_requested.user_id = current_user.id
      group_requested.group_id = params[:group]
      group_requested.save
    end
  end
  
  def group_request_pending
    @group = Group.find(params[:group])
  end
  
  def group_request_delete
    @group = Group.find(params[:group])
    conditions = {:user_id => current_user.id, :group_id => params[:group]}
    group_membership_to_delete = GroupMembership.where(conditions)
    unless group_membership_to_delete.empty?
      GroupMembership.destroy(group_membership_to_delete.map{|r| r.id})
      UserDefaultGroup.destroy(UserDefaultGroup.where(conditions).pluck(:id))
    end
  end

  def group_accept_received
    @group = Group.find(params[:group])
    @user = User.find(params[:user])
    conditions = {:group_id => params[:group], :user_id => params[:user]}
    if GroupMembership.where(conditions).empty?
      @group_membership = GroupMembership.new(conditions)
      @group_membership.save
      current_user.follow!(@user)
    end
    GroupMembershipRequest.where(conditions).first.destroy
  end

  def group_accept_confirmed
    @group = Group.find(params[:group])
    @user = User.find(params[:user])
  end

  def member_requests
    @my_groups = my_groups
    @group = current_group
  end

  private

  def group_params
    params.require(:group).permit(:name,:short_name,:user_id, :group)
  end

  def set_group
    params.require(:id)
  end
end
