class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :only_admin, only: %i[index edit update]
  before_action :load_user, only: %i[edit update]

  def index
    @users = User.all
  end

  def edit; end

  def update
    @user.update!(user_params)
    redirect_to users_path
  end

  private

  def load_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :role)
  end

  def only_admin
    redirect_to(root_url) unless current_user.admin?
  end
end
