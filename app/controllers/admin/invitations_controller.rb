# frozen_string_literal: true

class Admin::InvitationsController < Admin::ApplicationController
  before_action :authenticate_user!
  before_action :set_invitation, only: [:show, :destroy]

  def index
    @invitations = current_user.invitations.order :guest_name
  end

  def show; end

  def new
    @invitation = current_user.invitations.new
  end

  def create
    @invitation = current_user.invitations.new(invitation_params)

    respond_to do |format|
      if @invitation.save
        format.html { redirect_to [:admin, @invitation], notice: t(".created") }
        format.json { render :show, status: :created, location: @invitation }
      else
        format.html { render :new }
        format.json { render json: @invitation.errors,
                             status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @invitation.destroy
    respond_to do |format|
      format.html { redirect_to admin_invitations_url, notice: t(".destroyed") }
      format.json { head :no_content }
    end
  end

  private
    def set_invitation
      @invitation = current_user.invitations.find(params[:id])
    end

    def invitation_params
      params.require(:invitation).permit(%i[guest_name guest_email])
    end
end
