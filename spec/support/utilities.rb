include ApplicationHelper

include ActionView::Helpers::NumberHelper
# include ActionController::Base.helpers.number_to_currency
# include ActionController::Base.helpers

include EmailSpec::Helpers
include EmailSpec::Matchers

def sign_in_rep(rep)
  visit signin_path
  fill_in "Email",    with: rep.email
  fill_in "Password", with: rep.password
  click_button "Sign in"
  # Sign in when not using Capybara as well.
  # cookies[:remember_token] = user.remember_token
end

def sign_in_admin(admin)
  visit new_admin_session_path
  fill_in "Email",    with: admin.email
  fill_in "Password", with: admin.password
  click_button "Sign in"
end
