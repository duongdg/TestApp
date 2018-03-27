class UsersController < ApplicationController

  def show
    @user = User.find_by id: params[:id]
    if @user.nil?
      flash[:danger] = t "no_user"
      redirect_to root_url
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t "title_content"
      redirect_to @user
    else
      render :new
    end

  end

    private

      def user_params
        params.require(:user).permit :name, :email, :password, :password_confirm
      end

end
