class ApplicationController < ActionController::API
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
