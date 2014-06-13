module ApplicationHelper
  def my_families
    @my_families ||= current_user.family_memberships.collect{ |r| r.family}
  end

  def set_default_family
    unless params[:family].nil?
      @set_fam = UserDefaultFamily.find_by_user_id(current_user.id) || UserDefaultFamily.new
      @set_fam.user_id = current_user.id
      @set_fam.family_id = params[:family]
      @set_fam.save
    end
  end

  def current_family
    default_family = UserDefaultFamily.find_by_user_id(current_user.id)
    has_default = !default_family.nil?
    @current_family ||= has_default ? Family.find(UserDefaultFamily.find_by_user_id(current_user.id).family_id) : nil
  end
end
