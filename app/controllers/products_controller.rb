class ProductsController < ApplicationController
  def all_products
    render json: Product.all.as_json
  end

  def first_product
    render json: Product.first.as_json
  end
end