class WishesController < ApplicationController
  before_action :set_wish, only: [:update, :edit, :destroy]

  def new
    @wish = Wish.new
  end

  def create
    @wish = Wish.new wish_params
    if @wish.save
      redirect_to @wish, notice: t('forms.messages.success') #, status: :created  
    else
      # flash.now[:error] = 'Fail'
      render :new, status: 422
    end
  end

  def show
    begin     
      @wish = Wish.find params[:id]
    rescue ActiveRecord::RecordNotFound
      redirect_to wishes_path, status: 301, 
        flash: { error: t('forms.messages.not_found')}
    end
  end

  def index
    @wishes = Wish.all.not_owned
  end

  def edit
  end

  def update
    # if request.xhr?
    #   flash[:notice] = t 'forms.messages.success'
    #   flash.keep :notice
    #   # render js: "window.location = #{your_path}"
    # end

    respond_to do |format|
      if @wish.update wish_params       
        @wishlist = if wish_params[:owned] == 'true'
          Wish.all.not_owned
        else
          Wish.all.owned
        end

        # flash.now[:notice] = t('forms.messages.success')
        format.html { redirect_to @wish, notice: t('forms.messages.success') }
        format.js
      else
        format.html { render :edit, status: 422 } 
      end
    end
  end

  def destroy
    @wish.destroy
    redirect_to wishes_path, notice: t('forms.messages.success')
  end

  def owned
    @wishes = Wish.all.owned
    render :index
  end

  private
  def wish_params
    params.require(:wish).permit(:title, :priority, :price, :description, :owned)
  end

  def set_wish
    @wish = Wish.find params[:id]
  end
end
