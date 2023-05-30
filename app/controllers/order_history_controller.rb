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
