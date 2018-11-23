# frozen_string_literal: true

require "application_system_test_case"

class Admin::InvitationsTest < ApplicationSystemTestCase
  setup do
    @invitation = invitations(:always_valid)
  end

  test "visiting the index" do
    visit admin_invitations_url
    assert_selector "h1", text: t("index.title")
    assert_selector "a", text: t("index.new")
    invitations_count = Invitation.where(user: @current_user).count
    assert_equal invitations_count, all("a.invitation").size
  end

  test "creating an Invitation" do
    visit admin_invitations_url
    click_on t("index.new")
    assert_selector "h1", text: t("new.title")
    t_fill_in :guest_name, with: "Novo convite"
    t_fill_in :guest_email, with: "novoconvite@email.com"
    t_click_submit :create
    t_assert_text "create.created"
  end

  test "showing an Invitation" do
    visit admin_invitation_url(@invitation)
    assert_selector "h1", text: t("show.title")
    assert_text @invitation.guest_name
    assert_text @invitation.guest_email
    assert_text @invitation.token
    assert_selector "a",
                    text: new_user_registration_path(@invitation.to_params_link)
  end

  test "destroying a Invitation" do
    old_count = Invitation.where(user: @current_user).count
    visit admin_invitations_url

    all("a.invitation").sample.click

    page.accept_confirm do
      click_on t(:destroy)
    end

    t_assert_text "destroy.destroyed"
    assert_equal (old_count - 1), Invitation.where(user: @current_user).count
  end
end
