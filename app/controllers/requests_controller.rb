class RequestsController < ApplicationController
  before_action :authenticate_user!
  
end
