class WishesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :user_public]
  before_action :authorize_user,
                only: [:edit, :update, :toggle_owned, :toggle_public, :destroy]

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
    @wishes = Wish.all.published.not_owned
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

  def toggle_owned
    # if request.xhr?
    #   flash[:notice] = t 'forms.messages.success'
    #   flash.keep :notice
    #   # render js: "window.location = #{your_path}"
    # end
    respond_to do |format|
      if @wish.toggle_owned # update owned: owned

        if request.xhr?
          @wishlist = case request.referrer
                      when personal_wishes_url
                        current_user.wishes
                      when owned_wishes_url
                        current_user.wishes.owned
                        # @wishlist = if @wish.owned?
                        #   #Wish.all.not_owned
                        #   current_user.wishes.not_owned
                        # else
                        #   current_user.wishes.owned
                        #   #Wish.all.owned
                        # end
                      else
                        # request.referrer == root_url
                        Wish.all.published.not_owned
                      end
        end

        format.html { redirect_to @wish, notice: t('forms.messages.success') }
        format.js
      else
        format.html { redirect_to @wish, alert: t(:error) }
        # format.js { render text: e.message, status: 403 }
      end
    end
  end

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
end
