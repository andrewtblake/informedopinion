module Users
  class RegistrationsController < Devise::RegistrationsController
    protected

    def build_resource(hash = nil)
      super
      resource.require_participation_consent = true
    end
  end
end
