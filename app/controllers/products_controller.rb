class ProductsController < ApplicationController
  #before_filter :authenticate_rep!  #only: [:show, :new, :create, :edit, :update, :destroy, :index, :import]
  #before_filter :is_admin,           only: [       :new, :create, :edit, :update, :destroy,         :import]

  load_and_authorize_resource

  def import
    Product.import(params[:file])
    flash[:success] = "Products imported."
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
      flash[:success] = "Product #{@product.item_number} added"
      redirect_to products_url
    else
      render 'new'
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    if @product.update_attributes(params[:product])
      flash[:success] = "Product updated"
      redirect_to products_url
    else
      render 'edit'
    end
  end

  def destroy
    @product = Product.find(params[:id])
    proditnum = "#{@product.item_number}"
    @product.destroy 
    flash[:success] = "Product #{proditnum} removed."
    redirect_to products_url
  end

end
