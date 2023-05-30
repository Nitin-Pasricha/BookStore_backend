class OrderItemsController < ApplicationController
    before_action :authenticate_user
    before_action :set_order_item, only: [:add_to_cart]
    before_action :find_order_item, only: [:destroy]

    def add_to_cart
        @order.amount = @order.amount + @store.price
        if @order_item.blank?
            create
        else
            @qty = @order_item.qty + 1
            update
        end
    end

    def create
        @order_item = OrderItem.new(store_id:params[:store_id], order_id: @order.id, qty: 1)
        if @order_item.save && @order.save
        render json:{
            status: {
            code: 200,
            message: "Added to cart successfully."
            },
            data: @order_item
        }, status: :ok
        else
        render json: {
            status: {
            code: 422,
            message: "Failed to add to cart."
            },
            errors: @order_item.errors
        }, status: :unprocessable_entity
        end
    end

    def update
        
        if @order_item.update(qty: @qty) && @order.save
            render json: {
                status: {
                    code: 200,
                    message: "Order item with store_id #{params[:store_id]} successfully updated."
                },
                data: @order_item
            }, status: :ok
        else
            render json: {
                status: {
                    code: 422,
                    message: "Failed to update order item with store_id #{store_id}."
                },
                errors: @order_item.errors
            }, status: :unprocessable_entity
        end
    end

    def destroy
        @order.amount = @order.amount - (@order_item.qty * @order_item.store.price)
        @order.save
        @order_item.destroy
        render json: {
        status: {
            code: 200,
            message: "order item with id #{params[:id]} destroyed successfully."
        }
        }, status: :ok
    end

    private
    
    def set_order_item
        @store = Store.find_by_id(params[:store_id])
        if @store && @store.store_available?
            @order = Order.where(user_id: current_user.id).find_by_status('in_cart')
            if @order.blank?
                @order = Order.new(user_id: current_user.id)
                @order.save
            else
                @order_item = @order.order_items.find_by_store_id(params[:store_id])
            end
        else
            render json: {
                status: {
                    code: 404,
                    message: "Store with id: #{params[:store_id]} not found."
                }
            }
        end
    end

    def find_order_item
        @order = Order.where(user_id: current_user.id).find_by_status('in_cart')
        if @order
            @order_item = @order.order_items.find_by_id(params[:id])
            if @order_item.blank?
                render json: {
                    status: {
                        code: 404,
                        message: "Order Item with id: #{params[:id]} doesn't exist."
                    }
                }
            end
        else
            render json: {
                status: {
                    code: 404,
                    message: "You don't have an active order. Your cart is empty."
                }
            }
        end
    end
    
end
