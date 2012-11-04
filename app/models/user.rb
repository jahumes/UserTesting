class User < ActiveRecord::Base
  before_create :set_default_roles
  rolify

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
  validates :password, :presence => true, :confirmation => true
  validates :password_confirmation, :presence => true
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

  private
    def set_default_roles
      if !Role.find_by_name('normal').nil?
        self.roles << Role.find_by_name('normal')
      end

    end

end
