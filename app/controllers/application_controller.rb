class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  private

    def current_ability
        if current_admin
            @current_ability = Ability.new(current_admin)
        elsif current_rep
            @current_ability = Ability.new(current_rep)
        end
    end
end
