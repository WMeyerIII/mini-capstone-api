class OrdersController < ApplicationController
  before_action :authenticate_user

  def index
    @orders = current_user.orders
    render :index
  end


  def show
    @order = current_user.orders.find_by(id: params["id"])
    render :show
  end


  def create
    carted_products = current_user.carted_products.where(status:"carted")

    calculated_subtotal = 0 
    carted_products.each do |carted_product|
      calculated_subtotal += carted_product.quantity * carted_product.product.price
    end
    #product.price * params[:quantity]

    calculated_tax = calculated_subtotal * 0.09
    calculated_total = calculated_subtotal + calculated_tax

    @order = Order.new(
      user_id: current_user.id,
      product_id: params[:product_id],
      quantity: params[:quantity],
      subtotal: calculated_subtotal,
      tax: calculated_tax,
      total: calculated_total
    )

    if @order.save
      render :show
    else
      render json: {errors: @order.errors.full_messages},
      status: 422
    end
  end

end
