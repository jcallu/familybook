module GroupHelper
  def get_group
    @get_group ||= (params[:group].nil? || !my_groups.map{|r| r.id}.include?(params[:group].to_i) ) ? current_group : Group.find(params[:group])
  end

  def current_group
    default_group = UserDefaultGroup.find_by_user_id(current_user.id)
    has_default = !default_group.nil?
    @current_group ||= has_default ? Group.find(UserDefaultGroup.find_by_user_id(current_user.id).group_id) : nil
  end

  def my_groups
    @my_groups ||= current_user.group_memberships.collect{ |r| r.group}
  end

  def my_group_requests_for(group)
    current_user.group_membership_requests.find_by_group_id(group.id)
  end

  def set_default_group
    chosen_id = params[:group].to_i if my_groups.map{|r| r.id}.include?(params[:group].to_i)
    unless chosen_id.nil?
      @set_fam = UserDefaultGroup.find_by_user_id(current_user.id) || UserDefaultGroup.new
      @set_fam.user_id = current_user.id
      @set_fam.group_id = chosen_id
      @set_fam.save
    end
  end

  def current_user_group_id(user)
    group = UserDefaultGroup.find_by_user_id(user.id)
    group.nil? ? nil : Group.find(group.group_id).id
  end

  def current_user_owner?(group)
    group.owner_id == current_user.id
  end

  def group_members(group)
    unless group.nil?
      User.find(GroupMembership.where("group_id = #{group.id}").map{|r| r.user_id})
    else
      nil
    end
  end
end
