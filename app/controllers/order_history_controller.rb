class OrderHistoryController < ApplicationController
    before_action :authenticate_user
    before_action :set_order_history, only: [:index]

    def index
        render json: {
            status: {
                code: 200,
                message: 'Order history fetched successfully.'
            },
            data: @line_items
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
