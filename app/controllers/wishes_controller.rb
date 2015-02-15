class WishesController < ApplicationController
  def new
    @wish = Wish.new
  end

  def create
    @wish = Wish.new wish_params
    if @wish.save
      redirect_to @wish, notice: 'Success' #, status: :created  
    else
      # flash.now[:error] = 'Fail'
      render :new, status: 422
    end
  end

  def show
    @wish = Wish.find params[:id]
  end

  # def index
  private
  def wish_params
    params.require(:wish).permit(:title, :priority, :price, :description)
  end
end
