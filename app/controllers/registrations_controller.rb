# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters
  before_action :check_invitation_token, only: %i[new create]

  def check_invitation_token
    return if Invitation.token_valid?(params[:invitation_token])
    raise ActionController::RoutingError, "Not Found"
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer
      .permit(:sign_up, keys: %i[name invitation_token guest_name])
  end
end
