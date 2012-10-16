class User < ActiveRecord::Base
  before_create :set_default_roles
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :remember_me

  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :password, :presence => true, :confirmation => true
  validates :password_confirmation, :presence => true
  validates :email, :presence => true
  validates_email_format_of :email

  private
    def set_default_roles
      if Role.where(:name => 'normal').nil?
        self.roles << Role.where(:name => 'normal').first
      end

    end

end
