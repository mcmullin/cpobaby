class OrdersController < ApplicationController
  before_filter :authenticate_rep!  #only: [:index, :show, :new, :create, :edit, :update, :destroy]
  before_filter :correct_rep,        only: [        :show,                :edit, :update          ]
  before_filter :is_admin,           only: [                                              :destroy]

  # GET /orders
  # GET /orders.json
  def index
    if current_rep.admin?
      @orders = Order.all
    else
      @orders = current_rep.orders.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @orders }
    end
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    @order = Order.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @order }
    end
  end

  # GET /orders/new
  # GET /orders/new.json
  def new
    @order = Order.new
    4.times { @order.line_items.build(params[:order_id]) }

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @order }
    end
  end

  # GET /orders/1/edit
  def edit
    @order = Order.find(params[:id])
  end

  # POST /orders
  # POST /orders.json
  def create
    # @order = Order.new(params[:order])
    @order = current_rep.orders.build(params[:order])

    respond_to do |format|
      if @order.save
        format.html { redirect_to @order, notice: 'Order was successfully created.' }
        format.json { render json: @order, status: :created, location: @order }
      else
        format.html { render action: "new" }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /orders/1
  # PUT /orders/1.json
  def update
    @order = Order.find(params[:id])

    respond_to do |format|
      if @order.update_attributes(params[:order])
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order = Order.find(params[:id])
    @order.destroy

    respond_to do |format|
      format.html { redirect_to orders_url }
      format.json { head :no_content }
    end
  end

  private

    def correct_rep
      @order = current_rep.orders.find_by_id(params[:id])
      redirect_to root_url if @order.nil?
    end

    def is_admin
      redirect_to(root_url) unless current_rep.admin?
    end
end