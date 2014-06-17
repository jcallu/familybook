module FamilyHelper
  def get_family
    @get_family ||= (params[:family].nil? || !my_families.map{|r| r.id}.include?(params[:family].to_i) ) ? current_family : Family.find(params[:family]) 
  end

  def current_family
    default_family = UserDefaultFamily.find_by_user_id(current_user.id)
    has_default = !default_family.nil?
    @current_family ||= has_default ? Family.find(UserDefaultFamily.find_by_user_id(current_user.id).family_id) : nil
  end

  def my_families
    @my_families ||= current_user.family_memberships.collect{ |r| r.family}
  end  
 
  def my_family_requests_for(family)
    current_user.family_membership_requests.find_by_family_id(family.id)
  end

  def set_default_family
    chosen_id = params[:family].to_i if my_families.map{|r| r.id}.include?(params[:family].to_i)
    unless chosen_id.nil?
      @set_fam = UserDefaultFamily.find_by_user_id(current_user.id) || UserDefaultFamily.new
      @set_fam.user_id = current_user.id
      @set_fam.family_id = chosen_id
      @set_fam.save
    end
  end
  
  def current_user_family_id(user)
    family = UserDefaultFamily.find_by_user_id(user.id)
    family.nil? ? nil : Family.find(family.family_id).id
  end
  
  def current_user_owner?(family)
    family.owner_id == current_user.id
  end
  
  def family_members(family)
    unless family.nil?
      User.find(FamilyMembership.where("family_id = #{family.id}").map{|r| r.user_id})
    else
      nil
    end
  end
end
