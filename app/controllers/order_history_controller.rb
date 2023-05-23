class OrderHistoryController < ApplicationController
    before_action :authenticate_user
    before_action :set_order_history, only: [:index]

    def index
        items = Array.new
        for @line_item in @line_items do
            items.push({
                "id"=> @line_item.id,
                "store_id"=> @line_item.store_id,
                "title" => @line_item.store.title,
                "author" => @line_item.store.author,
                "price" => @line_item.store.price,
                "qty"=> @line_item.qty,
                "curr_stock_status" => @line_item.store.status
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
    def authenticate_user
        if !current_user
            render json: {
                status: {
                    code: 401,
                    message: 'Please log in to continue.'
                },
                errors: {'action': 'Unauthorized error.'}
            }, status: :unauthorized
        end
    end

    def set_order_history
        @line_items = LineItem.where(user_id: current_user).where(status: 'ordered')
    end
end
