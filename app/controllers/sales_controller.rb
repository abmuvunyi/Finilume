class SalesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_sale, only: %i[show edit update destroy]


  # GET /sales or /sales.json
  def index
    @sales = current_user.sales
  end

  # GET /sales/1 or /sales/1.json
  def show
  end

  # GET /sales/new
  def new
    @sale = current_user.sales.build
    @products = current_user.products.where('quantity > 0')
  end

  # GET /sales/1/edit
  def edit
  end

  # POST /sales or /sales.json
  def create
    @sale = current_user.sales.build(sale_params)
    @sale.date = Time.current

    if @sale.save
      # Reduce product stock quantity
      @sale.product.update(quantity: @sale.product.quantity - @sale.quantity)
      redirect_to @sale, notice: 'Sale was successfully created.'
    else
      @products = current_user.products.where('quantity > 0')
      render :new
    end
  end

  # PATCH/PUT /sales/1 or /sales/1.json
  def update
    respond_to do |format|
      if @sale.update(sale_params)
        format.html { redirect_to @sale, notice: "Sale was successfully updated." }
        format.json { render :show, status: :ok, location: @sale }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @sale.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sales/1 or /sales/1.json
  def destroy
    @sale.destroy!

    respond_to do |format|
      format.html { redirect_to sales_path, status: :see_other, notice: "Sale was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sale
      @sale = current_user.sales.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def sale_params
      params.require(:sale).permit(:product_id, :quantity, :total_price, :user_id, :date)
    end
end
