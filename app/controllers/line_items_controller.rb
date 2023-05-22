class LineItemsController < ApplicationController

    before_action :authenticate_user
    before_action :set_line_item, only: [:add_to_cart, :destroy]

    def add_to_cart
        if @line_item.blank?
            create
        else
            @qty = @line_item.qty + 1
            update
        end
    end

    def create
        @line_item = LineItem.new(store_id:params[:store_id], user_id:current_user.id)
        if @line_item.save
        render json:{
            status: {
            code: 200,
            message: "Added to cart successfully."
            },
            data: @line_item
        }, status: :ok
        else
        render json: {
            status: {
            code: 422,
            message: "Failed to add to cart."
            },
            errors: @line_item.errors
        }, status: :unprocessable_entity
        end
    end

    def update
        
        if @line_item.update(qty: @qty)
            render json: {
                status: {
                    code: 200,
                    message: "Line item with store_id #{params[:store_id]} successfully updated."
                },
                data: @line_item
            }, status: :ok
        else
            render json: {
                status: {
                    code: 422,
                    message: "Failed to update line item with store_id #{store_id}."
                },
                errors: @line_item.errors
            }, status: :unprocessable_entity
        end
    end

    def destroy
        @line_item.destroy
        render json: {
        status: {
            code: 200,
            message: "Line item with store_id #{params[:store_id]} destroyed successfully."
        }
        }, status: :ok
    end

    private
    
    def set_line_item
        @line_item = LineItem.where(user_id: current_user).where(status: 'in_cart').find_by_store_id(params[:store_id])
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
