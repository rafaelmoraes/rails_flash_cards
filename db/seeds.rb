# frozen_string_literal: true

User.create name: ENV["ADMIN_NAME"],
            email: ENV["ADMIN_EMAIL"],
            password: ENV["ADMIN_PASSWORD"],
            password_confirmation: ENV["ADMIN_PASSWORD"],
            invitation_token: "",
            admin: true
