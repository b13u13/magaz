require 'test_helper'
require 'pry'

class UserStoriesTest < ActionDispatch::IntegrationTest
	fixtures :products
	include ActiveJob::TestHelper

	test "buying a product" do
		start_order_count = Order.count
		ruby_book = products(:ruby)

		get store_url
		assert_response :success
		assert_template "index"

		post line_items_url, params: { product_id: ruby_book.id  }
		assert_redirected_to store_url

		cart = Cart.find(session[:cart_id])
		assert_equal 1, cart.line_items.size
		assert_equal ruby_book, cart.line_items[0].product

		get "/orders/new"
		assert_response :success
		perform_enqueued_jobs do
			post "/orders", params: {
					order: {
									name: "Dave Thomas",
									address: "123 The Street",
									email: "dave@example.com",
									pay_type: "Check"
									}
		}
			follow_redirect!


		assert_response :success


		cart = Cart.find(session[:cart_id])
		assert_equal 0, cart.line_items.size

		assert_equal start_order_count + 1, Order.count

		order = Order.last

		assert_equal "Dave Thomas", order.name
		assert_equal "123 The Street", order.address
		assert_equal "dave@example.com", order.email
		assert_equal "Check", order.pay_type

		assert_equal 1, order.line_items.size
		line_item = order.line_items[0]
		assert_equal ruby_book, line_item.product


		mail = ActionMailer::Base.deliveries.last
		assert_equal ["dave@example.com"], mail.to
		assert_equal 'EBB <depot@example.com>', mail[:from].value
		assert_equal "Подтверждение заказа в Pragmatic Store", mail.subject
		end
	end
end


