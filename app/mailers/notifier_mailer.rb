class NotifierMailer < ApplicationMailer
    default from: 'updates@bookstore.com'

    def order_confirmation_email
        @user = User.find(params[:user])
        @url = 'http://localhost:3000/stores'
        mail(to: @user.email, subject: 'Order Confirmation - Your Booklish order has been placed')
    end
end
