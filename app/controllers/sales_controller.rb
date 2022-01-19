class SalesController < ApplicationController
  def show
    @sale = Sale.find(params[:id])
  end
end
