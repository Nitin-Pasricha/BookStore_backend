class OrderHistoryController < ApplicationController
    before_action :authenticate_user
    before_action :set_order_history, only: [:index]

    def index
        items = Array.new
        for @order in @orders do
            items.push({
                "id"=> @order.id,
                "amount"=> "Rs. #{@order.amount}",
                "status"=> @order.status,
                "order_date"=> @order.order_date
            })
        end
        render json: {
            status: {
                code: 200,
                message: 'Order history fetched successfully.'
            },
            data: items
        }
    end

    def order_details
        @order = Order.where(user_id: current_user).find_by_id(params[:order_id])
        if @order.blank?
            render json: {
                status: {
                    code: 404,
                    message: "Order with order_id: #{params[:order_id]} not found."
                }
            }
        end
        items = Array.new
        for @order_item in @order.order_items do
            items.push({
                "id"=> @order_item.id,
                "store_id"=> @order_item.store_id,
                "title"=> @order_item.store.title,
                "author"=> @order_item.store.author,
                "price"=> @order_item.store.price,
                "qty"=> @order_item.qty,
                "current_stock_status"=> @order_item.store.status
            })
        end

        render json: {
            status: {
                code: 200,
                message: 'Order details fetched successfully.'
            },
            data: items
        }
    end

    private

    def set_order_history
        @orders = Order.where(user_id: current_user).where(status:'ordered')
        if @orders.blank?
            render json: {
                status: {
                    code: 422,
                    message: "You don't have any order history."
                }
            }, status: :unprocessable_entity
        end
    end
end
