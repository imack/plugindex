class HomeController < ApplicationController
  def index

    @stats = Stats.order_by([:created_at, :desc]).first

    if @stats.nil?
      @stats = Stats.new
    end

    respond_to do |format|
      format.html
    end
  end


end
