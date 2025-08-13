class SalesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_sale, only: %i[show edit update destroy]
  before_action :set_products_collection, only: %i[new create edit update]

  def index
    @sales = current_user.sales.order(created_at: :desc)
  end

  def show; end

  def new
    # Keep discount blank by default so the field shows placeholder and doesn’t force typing over “0.00”
    @sale = current_user.sales.build(discount_amount: nil)
  end

  def edit; end

  def create
    @sale = current_user.sales.new(sale_params)
    # NOTE:
    # - total_price is computed in Sale model (before_validation)
    # - date is set from timestamp in Sale model (before_validation)
    # - stock decrement + income creation happen in Sale callbacks

    if @sale.save
      redirect_to @sale, notice: t("sales.flash.created", default: "Sale was successfully created.")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @sale.update(sale_params)
      redirect_to @sale, notice: t("sales.flash.updated", default: "Sale was successfully updated.")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @sale.destroy!
    redirect_to sales_path, status: :see_other, notice: t("sales.flash.destroyed", default: "Sale was successfully destroyed.")
  end

  private

  def set_sale
    @sale = current_user.sales.find(params[:id])
  end

  def set_products_collection
    # Only user’s products that have stock > 0
    @products = current_user.products.where("quantity > 0").order(:name)
  end

  # Do NOT permit :total_price (computed in model).
  # :date is permitted only to allow backdated/late entries manually if you ever show a date field again.
  def sale_params
    params.require(:sale).permit(:product_id, :quantity, :discount_amount, :date)
  end
end
