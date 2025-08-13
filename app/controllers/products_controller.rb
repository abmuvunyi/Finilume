class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product, only: %i[show edit update destroy]

  def index
    @products = current_user.products.order(created_at: :desc)
  end

  def show; end

  def new
    @product = current_user.products.new
  end

  def edit; end

  def create
    @product = current_user.products.new(product_params)

    if @product.save
      redirect_to @product, notice: t("products.flash.created", default: "Product was successfully created.")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      redirect_to @product, notice: t("products.flash.updated", default: "Product was successfully updated.")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy!
    redirect_to products_path, status: :see_other, notice: t("products.flash.destroyed", default: "Product was successfully destroyed.")
  end

  private

  def set_product
    @product = current_user.products.find(params[:id])
  end

  # Add :cost_price (we compute profit in model/services; expenses are created via model callback)
  def product_params
    params.require(:product).permit(:name, :category, :price, :quantity, :cost_price)
  end
end
