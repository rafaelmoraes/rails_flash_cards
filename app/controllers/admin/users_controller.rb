# frozen_string_literal: true

class Admin::UsersController < Admin::ApplicationController
  before_action :set_user, only: :destroy

  def index
    @users = ::User.select(:id, :name, :email, :last_sign_in_at)
                   .where(admin: false)
                   .order :name
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to admin_users_url, notice: t(".destroyed") }
      format.json { head :no_content }
    end
  end

  private
    def set_user
      @user = ::User.find(params[:id])
    end
end
