class UsersController < Devise::RegistrationsController
  authorize_resource
end
