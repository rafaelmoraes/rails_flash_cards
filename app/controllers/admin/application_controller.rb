# frozen_string_literal: true

class Admin::ApplicationController < ::ApplicationController
  before_action :check_user_role!

  def check_user_role!
    raise ActionController::RoutingError, "Not Found" if !current_user&.admin?
  end
end
