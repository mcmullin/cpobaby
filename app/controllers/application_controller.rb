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
    
=begin
    def current_ability
      if current_account.kind_of?(Admin)
        @current_ability ||= AdminAbility.new(current_account)
      else
        @current_ability ||= RepAbility.new(current_account)
      end
    end
=end
end
