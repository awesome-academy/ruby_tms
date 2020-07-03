class User < ApplicationRecord
  enum roles: {trainee: 0, trainer: 1}
  # relations:
  has_many :subjects

  has_secure_password

end
