class Store < ApplicationRecord
    validates :title, presence: true
    validates :author, presence: true
    validates :price, presence: true

    enum status: [:store_available, :store_unavailable]
end
