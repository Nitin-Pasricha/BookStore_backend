class CartController < ApplicationController
    before_action :authenticate_user
    before_action :set_cart, only: [:index, :empty_cart, :checkout]

    def index
        items = Array.new
        total_amount = 0
        for @line_item in @line_items do
            curr_amount = @line_item.qty * @line_item.store.price
            total_amount = total_amount + curr_amount
            items.push({
                "id"=> @line_item.id,
                "store_id"=> @line_item.store_id,
                "title" => @line_item.store.title,
                "author" => @line_item.store.author,
                "price" => @line_item.store.price,
                "qty"=> @line_item.qty
            })
        end

        render json: {
            status: {
                code: 200,
                message: 'Cart successfully loaded.'
            },
            data: items,
            total_amount_to_be_paid: total_amount
        }, status: :ok
    end

    def empty_cart
        @line_items.delete_all
        render json: {
        status: {
            code: 200,
            message: "Cart items deleted successfully."
        }
        }, status: :ok
    end

    def checkout
        if @line_items.size()>0
            for @line_item in @line_items do
                @line_item.status = 1
                @line_item.save
            end

            
            EmailSchedulerJob.perform_async(current_user.id.to_i)

            render json: {
                status: {
                    code: 200,
                    message: 'Order placed successfully.'
                }
            }, status: :ok
        else
            render json: {
                status: {
                    code: 422,
                    message: 'Cart is empty! Please add items in cart.'
                }
            }, status: :unprocessable_entity
        end
    end

    private
    def set_cart
        @line_items = LineItem.where(user_id: current_user).where(status: 'in_cart')
    end

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
end
