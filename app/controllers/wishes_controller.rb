class WishesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :user_public]
  before_action :authorize_user,
                only: [:edit, :update, :toggle_owned, :cancel_owned, :toggle_public, :destroy]
                # except: [:new, :create, :show, :index, :user_public]
  def new
    @wish = current_user.wishes.build
  end

  def create
    # @wish = Wish.new wish_params
    @wish = current_user.wishes.build wish_params
    if @wish.save
      redirect_to @wish, notice: t('forms.messages.success')
      # , status: :created
    else
      # flash.now[:error] = 'Fail'
      render :new, status: 422
    end
  end

  def show
    wish = Wish.find params[:id]
    @wish = current_user == wish.user ? wish : Wish.published.find(params[:id])

    # @wish = Wish.find params[:id]
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path,
                status: 301,
                flash: { error: t('forms.messages.not_found') }
  end

  def index
    @wishes = Wish.all.published.not_owned.includes :user
  end

  def edit
  end

  def update
    if @wish.update wish_params
      redirect_to @wish, notice: t('forms.messages.success')
    else
      render :edit, status: 422
    end
  end

  # def cancel_owned
  #   @wish.toggle_owned
  #   @wishes = current_user.wishes.owned
  #   respond_to do |format|
  #     format.js { render 'toggle_owned.coffee' }
  #     format.html { redirect_to :back }
  #   end
  # end

  def toggle_owned
    # request.xhr?
    @wish.toggle_owned
    @wishes = wishes_by_referrer
    respond_to do |format|
      format.js
      format.html { redirect_to :back, notice: t('forms.messages.success') }
    end
  end

  # js only
  def toggle_public
    if @wish.update public: !@wish.public
      redirect_to @wish, notice: t('forms.messages.success')
    else
      redirect_to @wish, alert: t(:error)
    end
  end

  def destroy
    @wish.destroy
    redirect_to personal_wishes_path, notice: t('forms.messages.success')
  end

  def owned
    @wishes = current_user.wishes.owned
    # Wish.all.owned
    render :index
  end

  def personal # alias all
    @wishes = current_user.wishes
    render :index
  end

  # GET users/:id/wishes
  def user_public
    user = User.find params[:id]
    @wishes = user.wishes.published.not_owned
    render :index
  end

  private

  def wish_params
    params.require(:wish).permit :title, :priority, :price, :description,
                                 :owned, :picture, :public
  end

  def authorize_user
    @wish = current_user.wishes.find_by id: params[:id]

    msg = t('devise.failure.unauthenticated')
    redirect_to root_path, alert: msg unless @wish
  end

  def wishes_by_referrer
    case request.referrer
    when personal_wishes_url
      current_user.wishes
    when owned_wishes_url
      current_user.wishes.owned
    else
      # root_url
      Wish.all.published.not_owned
    end
  end
end
