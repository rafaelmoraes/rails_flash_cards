# frozen_string_literal: true

# User Settings controller
class SettingsController < ApplicationController
  before_action :set_setting, only: %i[index update]

  def index; end

  def update
    respond_to do |format|
      if @setting.update(setting_params)
        set_locale
        format.html { redirect_to settings_path, notice: t('.updated') }
        format.json { render :index, status: :ok, location: @setting }
      else
        format.html { render :index }
        format.json do
          render json: @setting.errors,
                 status: :unprocessable_entity
        end
      end
    end
  end

  private

  def set_setting
    @setting = current_user.setting
  end

  def setting_params
    params.require(:setting).permit :locale,
                                    :cards_per_review,
                                    :repeat_easy_card,
                                    :repeat_medium_card,
                                    :repeat_hard_card
  end
end
