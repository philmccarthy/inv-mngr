class ItemsController < ApplicationController
  before_action :set_item, except: %i[index new create]

  def index
    @items = Item.order_by_created_at
  end

  def show; end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.valid?
      @item.save
      flash.notice = 'Item was added successfully.'
      redirect_to items_path
    else
      flash[:alert] = @item.errors.full_messages
      redirect_to new_item_path
    end
  end

  def edit; end

  def update
    if @item.update(item_params)
      flash.notice = 'Item successfully updated'
      redirect_to items_path
    else
      flash[:error] = @item.errors.full_messages
      set_item
      redirect_to edit_item_path(@item)
    end
  end

  def destroy
    @item.update(enabled: false)
    @item.purchases.update_all(enabled: false)
    @item.sales.update_all(enabled: false)
    flash.notice = 'Item was deleted successfully.'
    redirect_to items_path
  end

  def undelete
    @item.update(enabled: true)
    @item.purchases.update_all(enabled: true)
    @item.sales.update_all(enabled: true)
    flash.notice = "#{@item.name} was restored!"
    redirect_to items_path
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :category, :initial_stock)
  end

  def set_item
    @item = Item.find(params[:id])
  end
end
