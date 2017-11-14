class Product < ApplicationRecord
	validates :title, :description,  :image_url, presence: true
	validates :price, numericality: { greather_than_or_equal_to: 0.01 }
	validates :title, uniqueness: true
	validates :image_url, allow_blank: true, format: {

	}
end
