class ProductsController < ApplicationController
  load_and_authorize_resource

  def import
    Product.import(params[:import_products][:file_input])
    flash[:success] = 'Products imported.'
    redirect_to products_url
  end

  def index
    @products = Product.order(:item_number)
    # @products = Product.all.sort_by(&:position) # broke .csv export, so moved sorting to view
    respond_to do |format|
      format.html
      format.csv { send_data @products.to_csv }
    end
  end

  def show
    @product = Product.find(params[:id])
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(params[:product])
    if @product.save
      if @product.submit
        flash[:success] = "Product ##{@product.item_number} added."
        redirect_to products_url
      else
        flash[:warning] = "Product ##{@product.item_number} added, but record is incomplete."
        redirect_to edit_product_url(@product)
      end
    else
      render 'new'
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    if @product.update_attributes(params[:product]) && @product.submit
      flash[:success] = "Product ##{@product.item_number} updated and submitted for review."
      redirect_to products_url
    else
      render 'edit'
    end
  end

  def destroy
    @product = Product.find(params[:id])
    product_item_number = "#{@product.item_number}"
    @product.destroy 
    flash[:success] = "Product ##{product_item_number} removed."
    redirect_to products_url
  end

end
