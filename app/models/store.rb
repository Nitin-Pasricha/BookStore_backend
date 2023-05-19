class Store < ApplicationRecord
    validates :title, presence: true
    validates :author, presence: true
    validates :price, presence: true
end
