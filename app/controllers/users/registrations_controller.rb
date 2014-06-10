class Users::RegistrationsController < Devise::RegistrationsController

  def create
    super
    this_user = current_user
    unless this_user.nil?
      @user = User.find(this_user.id)
      @user.avatar_url_thumb = @user.avatar.url(:thumb)
      @user.avatar_url_original = @user.avatar.url(:original)
      @user.save
    end
  end

  def update
    super
    @user = User.find(current_user.id)
    @user.avatar_url_thumb = @user.avatar.url(:thumb)
    @user.avatar_url_original = @user.avatar.url(:original)
    @user.save
  end
  
  def resource_params
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password)
  end
  private :resource_params

  private
  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
 
  def account_update_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password, :avatar, :avatar_url_thumb, :avatar_url_original)
  end
end
