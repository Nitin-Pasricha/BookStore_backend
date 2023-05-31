class CartController < ApplicationController
    before_action :authenticate_user
    before_action :set_cart, only: [:index, :empty_cart, :checkout]

    # GET cart
    def index
        items = Array.new
        for @order_item in @order.order_items do
            items.push({
                "id"=> @order_item.id,
                "store_id"=> @order_item.store_id,
                "title" => @order_item.store.title,
                "author" => @order_item.store.author,
                "price" => @order_item.store.price,
                "qty"=> @order_item.qty
            })
        end

        render json: {
            status: {
                code: 200,
                message: 'Cart successfully loaded.'
            },
            data: {
                order_id: @order.id,
                order_items: items,
                total_amount_to_be_paid: @order.amount
            }
        }, status: :ok
    end

    # DELETE empty_cart
    def empty_cart
        @order.destroy
        render json: {
        status: {
            code: 200,
            message: "Cart items deleted successfully."
        }
        }, status: :ok
    end

    # POST checkout
    def checkout
        @order.status = "ordered"
        @order.order_date = DateTime.now()
        @order.save

        
        EmailSchedulerJob.perform_async(current_user.id.to_i)

        render json: {
            status: {
                code: 200,
                message: 'Order placed successfully.'
            }
        }, status: :ok
    end

    private

    def set_cart
        @order = Order.where(user_id: current_user.id).find_by_status('in_cart')
        if @order.blank? || @order.order_items.size == 0
            render json: {
                status: {
                    code: 422,
                    message: 'Cart is empty! Please add items in cart.'
                }
            }, status: :unprocessable_entity
        end

    end
end
