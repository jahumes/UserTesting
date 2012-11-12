class Contact < ActiveRecord::Base
  attr_accessible :email, :first_name, :last_name, :phone

  validates_presence_of :first_name
  validates_presence_of :last_name

  include PgSearch
  pg_search_scope :search_by_full_name,
                  :against => [:first_name, :last_name, :email],
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

  def name
    [first_name, last_name].join " "
  end

  def self.by_letter(letter)
    where("last_name LIKE ?", "#{letter}%").order(:last_name)
  end

  private
    def sort_column
      User.column_names.include?(params[:sort]) ? params[:sort] : "last_name"
    end
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
    def per_page
      [5,10,20,50,100].include?(params[:per_page].to_f) ? params[:per_page] : 5
    end
end
