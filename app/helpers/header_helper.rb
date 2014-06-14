module HeaderHelper
  def get_family
    @get_family ||= params[:family].nil? ? current_family : Family.find(params[:family])
  end

  def current_family
    default_family = UserDefaultFamily.find_by_user_id(current_user.id)
    has_default = !default_family.nil?
    @current_family ||= has_default ? Family.find(UserDefaultFamily.find_by_user_id(current_user.id).family_id) : nil
  end

  def my_families
    @my_families ||= current_user.family_memberships.collect{ |r| r.family}
  end
end
