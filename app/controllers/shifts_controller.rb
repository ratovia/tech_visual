class ShiftsController < ApplicationController
  def index
    t = Time.new
    @str = t.strftime("%Y %m/%d")
  end
end
