class StoresController < ApplicationController
    before_action :authenticate_admin, only: [:create, :update, :destroy]
    before_action :set_store, only: [:show, :update, :destroy]

    def index
        if current_user && current_user.admin?
            @stores = Store.all
        else
            @stores = Store.where(status:'store_available')
        end
        render json: {
        status: {
            code: 200,
            message: "All stores fetched successfully."
        },
        data: @stores
        }, status: :ok
    end

    def show
        render json: {
        status: {
            code: 200,
            message: "Store with id #{params[:id]} exists."
        },
        data: @store
        }, status: :ok
    end

    def create
        @store = Store.new(store_params)
        if @store.save
        render json:{
            status: {
            code: 200,
            message: "New store successfully created"
            },
            data: @store
        }, status: :ok
        else
        render json: {
            status: {
            code: 422,
            message: "Failed to create new store."
            },
            errors: @store.errors
        }, status: :unprocessable_entity
        end
    end

    def update
        if @store.update(store_params)
            render json: {
                status: {
                    code: 200,
                    message: "Store with id #{params[:id]} successfully updated."
                },
                data: @store
            }, status: :ok
        else
            render json: {
                status: {
                    code: 422,
                    message: "Failed to update store with id #{id}."
                },
                errors: @store.errors
            }, status: :unprocessable_entity
        end
    end

    def destroy
        @store.status = 1
        @store.save
        render json: {
        status: {
            code: 200,
            message: "Store with id #{params[:id]} removed successfully."
        }
        }, status: :ok
    end


    private

    def store_params
        params.require(:store).permit(:title, :author, :description, :price, :status)
    end

    def set_store
        @store = Store.find_by_id(params[:id])
        if @store.nil?
        render json: {
            status: {
            code: 404,
            message: "Store with id #{params[:id]} doesn't exist."
            }
        }, status: :unprocessable_entity
        end
    end

    def authenticate_admin
        
        if current_user.blank? || current_user.role!="admin"
            render json: {
                status: {
                    code: 401,
                    message: "Please log in as admin."
                },
                errors: {"action":"Unauthorized Action"}
            }, status: :unauthorized
        end
    end
end
  
