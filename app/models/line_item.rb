class LineItem < ApplicationRecord
    belongs_to :store
    belongs_to :user

    enum status: [:in_cart, :ordered]
end
