class ProductsController < ApplicationController
  #before_filter :authenticate_rep!  #only: [:show, :new, :create, :edit, :update, :destroy, :index, :import]
  #before_filter :is_admin,           only: [       :new, :create, :edit, :update, :destroy,         :import]

  load_and_authorize_resource

  respond_to :html, :json

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

=begin
  def update
    @product = Product.find(params[:id])
    if @product.update_attributes(params[:product])
      flash[:success] = "Product updated"
      redirect_to products_url
    else
      render 'edit'
    end
  end



  def update
    @product = Product.find(params[:id])

    respond_to do |format|
      if @product.update_attributes(params[:product])
        format.html { redirect_to(@product, :notice => 'Product was successfully updated.') }
        format.json { respond_with_bip(@product) }
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip(@product) }
      end
    end
  end



  def update
    @product = Product.find(params[:id])
    if @product.update_attributes(params[:product])
      flash[:success] = "Successfully updated #{@product.item}"
    end
    # respond_with(@product, :location => products_url)
  end
=end

  def update
    @product = Product.find(params[:id])
    @product.update_attributes(params[:product])
    respond_with @product
  end

  def destroy
    @product = Product.find(params[:id])
    #if current_rep.admin? 
      proditnum = "#{@product.item_number}"
      @product.destroy 
      flash[:success] = "Product #{proditnum} removed."
      redirect_to products_url
    #else
    #  flash[:error] = "You do not have permission to remove Product #{proditnum}"
    #  redirect_to products_url
    #end
  end

  def index
    @products = Product.order(:item_number)
    respond_to do |format|
      format.html
      format.csv { send_data @products.to_csv }
      format.xls #{ send_data @products.to_csv(col_sep: "\t") }
    end
  end

  def import
    Product.import(params[:file])
    flash[:success] = "Products imported."
    redirect_to products_url
  end

  private

    def is_admin
      redirect_to(root_url) unless current_rep.admin?
    end
end
