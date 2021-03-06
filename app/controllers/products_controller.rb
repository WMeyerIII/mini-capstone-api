class ProductsController < ApplicationController
  before_action :authenticate_admin, except: [:index, :show]
  
  def index
    @products = Product.all
    if params[:category]
      category = Category.find_by(name: params[:category])
      @products = category.products
    end
    render template: "products/index"
  end
    #render :index ^^^ keep just for the reference
    # render json: Product.all.as_json(methods: [:is_discounted, :tax, :total])

  def show
    product_id = params["id"]
    @product = Product.find_by(id: product_id)
    render template: "products/show"
    # render json: @product.as_json(methods: [:is_discounted, :tax, :total])
  end

  def create
    @product = Product.new(
      name: params["name"],
      price: params["price"],
      # image_url: params["image_url"],
      description: params["description"],
      supplier_id: params["supplier_id"]
    )
    if @product.save
      render :show
      # render template: "products/show"
    else
      render json: {errors: @product.errors.full_messages}, status: 422
    end
  end
  
  def update
    product_id = params[:id]
    @product = Product.find_by(id: product_id)

    @product.name = params["name"] || @product.name
    @product.price = params["price"] || @product.price
    # @product.image_url = params["image_url"] || @product.image_url
    @product.description = params["description"] || @product.description
    
    if @product.save
      render template: "products/show"
    else
      render json: {errors: @product.errors.full_messages}, status: 422
    end
  end

  def destroy
    product_id = params[:id]
    product = Product.find_by(id:product_id)
    product.destroy
    render json: {message: "MY GOD WHAT HAVE YOU DONE?!"}
  end
end
