class WishesController < ApplicationController
  # before_action :set_wish, only: [:update, :toggle_owned, :toggle_public, :edit, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :authorize_user, only: [:edit, :update, :toggle_owned, :toggle_public, :destroy]

  def new
    @wish = current_user.wishes.build #Wish.new
  end

  def create
    # @wish = Wish.new wish_params
    @wish = current_user.wishes.build wish_params
    if @wish.save
      redirect_to @wish, notice: t('forms.messages.success') #, status: :created  
    else
      # flash.now[:error] = 'Fail'
      render :new, status: 422
    end
  end

  def show
    begin    
      wish = Wish.find params[:id]  
      if current_user == wish.user
        @wish = wish
      else
        @wish = Wish.published.find params[:id]
      end      
      # @wish = Wish.find params[:id]
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path, status: 301, 
        flash: { error: t('forms.messages.not_found')}
    end
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
      if @wish.toggle_owned #update owned: owned
        
        @wishlist = if @wish.owned?
          #Wish.all.not_owned
          current_user.wishes.not_owned
        else
          current_user.wishes.owned
          #Wish.all.owned
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
    if @wish.update public: not(@wish.public)
      redirect_to @wish, notice: t('forms.messages.success')
    else
      redirect_to @wish, alert: t(:error)
    end
  end

  def destroy
    @wish.destroy
    redirect_to all_wishes_path, notice: t('forms.messages.success')
  end

  def owned
    @wishes = current_user.wishes.owned
    #Wish.all.owned
    render :index
  end

  def all
    @wishes = current_user.wishes
    #Wish.all
    render :index
  end

  private
  def wish_params
    params.require(:wish).permit :title, :priority, :price, 
      :description, :owned, :picture, :public
  end

  # def set_wish
  #   @wish = Wish.find params[:id]
  # end

  def authorize_user
    @wish = current_user.wishes.find_by id: params[:id]
    redirect_to root_path, notice: 'Not authorized' unless @wish
  end
end
