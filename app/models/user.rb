class User < ActiveRecord::Base
  before_create :set_default_roles
  before_update :set_default_roles
  rolify

  delegate :can?, :cannot?, :to => :ability

  has_and_belongs_to_many :roles, :join_table => :users_roles

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :remember_me, :role_ids

  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :password,
            :presence => true,
            :length => {:within => 6..40},
            :on => :create,
            :confirmation => true,
            :if => lambda{ new_record? || !password.nil? }
  validates :password_confirmation, :presence => true, :on => :create
  validates :email, :presence => true
  validates_email_format_of :email

  include PgSearch
  pg_search_scope :search_by_full_name,
                  :against => [:first_name, :last_name],
                  :using => {
                      :tsearch => {:prefix => true}
                  }

  def self.search(search)
    if !search.blank? && search
      self.search_by_full_name(search)
    else
      scoped
    end
  end

  def current_ability
    current_user.ability
  end

  protected
    def password_required?
      false
    end

  private
    def set_default_roles
      if !Role.find_by_name('normal').nil?
        self.roles << Role.find_by_name('normal')
      end
    end

end
