class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_date_loaded



  private

  def set_date_loaded
  	@date_loaded = Time.now
  end

end
