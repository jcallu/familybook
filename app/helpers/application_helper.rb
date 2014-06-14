module ApplicationHelper
  def set_default_family
    chosen_id = params[:family]
    unless chosen_id.nil?
      @set_fam = UserDefaultFamily.find_by_user_id(current_user.id) || UserDefaultFamily.new
      @set_fam.user_id = current_user.id
      @set_fam.family_id = chosen_id
      @set_fam.save
    end
  end
end
