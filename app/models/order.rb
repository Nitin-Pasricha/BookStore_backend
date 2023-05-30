class Order < ApplicationRecord
    has_many :order_items, dependent: :destroy

    enum status: [:in_cart, :ordered]
end
