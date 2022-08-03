class StaticPagesController < ApplicationController

  def credits
    render 'credits'
  end

  def privacy
    render 'privacy'
  end
end
