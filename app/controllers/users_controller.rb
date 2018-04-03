class UsersController < ApplicationController
  before_action :logged_in_user, only: %i(:index edit update destroy
    following followers)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy
  before_action :find_by_id, except: %i(index new create)

  def index
    @users = User.paginate(page: params[:page], :per_page => 15).order "created_at desc"
  end

  def show
    if @user.nil?
      flash[:danger] = t "no_user"
      redirect_to root_url
    else
      @microposts = @user.microposts.paginate(page: params[:page])
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "please_check"
      redirect_to root_url
    else
      render :new
    end

  end

  def edit
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "pro_update"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] = t "destroy_user"
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

  def find_by_id
    @user = User.find_by id: params[:id]
  end

  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirm
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = t "please"
      redirect_to login_url
    end
  end

  def current_user? user
    user == current_user
  end

  def correct_user
    @user = User.find_by id: params[:id]
    redirect_to root_url unless current_user? @user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

end
