class Product < ApplicationRecord
	validates :title, :description,  :image_url, presence: true
	validates :price, numericality: { greather_than_or_equal_to: 0.01 }
	validates :title, uniqueness: true
	validates :image_url, allow_blank: true, format: {
		with: %r{\.(.gif|jpg|png)\Z}i,
		message: 'URL должен указывать на изображения формата GIF, JPG или PNG.'
	}
end
