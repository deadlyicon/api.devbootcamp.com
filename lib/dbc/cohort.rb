class Dbc::Cohort < ActiveRecord::Base

  has_many :members, class_name: 'Dbc::User'
  belongs_to :location

  before_validation :generate_slug, :generate_email

  validates_presence_of :name, :email, :slug, :start_date
  validates_uniqueness_of :name, :email, :slug

  def location= location
    location = Dbc::Location.where(name:location).first! if !location.is_a? Dbc::Location
    super location
  end

  private

  def generate_slug
    self.slug ||= name.gsub(/\s/,'_')
  end

  def generate_email
    return if start_date.blank?
    self.email ||= "#{name.gsub(/\W+/,'.')}-#{start_date.year}@devbootcamp.com"
  end

end
