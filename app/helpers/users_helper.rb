module UsersHelper
  def current_user_family
    family = UserDefaultFamily.find_by_user_id(current_user.id)
    Family.find(family.family_id) unless family.nil?
  end
end
