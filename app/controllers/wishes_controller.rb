class WishesController < ApplicationController
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
    rescue Exception => e
      redirect_to wishes_path, status: 301, 
        flash: { error: t('forms.messages.not_found')}
    end
  end

  def index
    @wishes = Wish.all
  end

  def edit
    @wish = Wish.find params[:id]
  end

  def update
    @wish = Wish.find params[:id]
    if @wish.update wish_params
      redirect_to @wish, notice: t('forms.messages.success')
    else
      render :edit, status: 422
    end
  end

  def destroy
    @wish = Wish.find params[:id]
    @wish.destroy
    redirect_to wishes_path, notice: t('forms.messages.success')
  end

  private
  def wish_params
    params.require(:wish).permit(:title, :priority, :price, :description)
  end
end
