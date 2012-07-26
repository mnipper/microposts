class User < ActiveRecord::Base
  has_secure_password

  attr_accessible :name, :email, :password, :password_confirmation 

  before_save { |user| user.email = user.email.downcase }

  validates :name, :presence => true, :length => { :maximum => 50 }
  validates :email, :presence => true, :uniqueness => { :case_sensitive => false }, :format => { :with => /\A[\w+\-.]+@[\w+\-.]+\.[a-z]+\z/i  }
  validates :password, :presence => true, :length => { :minimum => 6 }
  validates :password_confirmation, :presence => true
end
