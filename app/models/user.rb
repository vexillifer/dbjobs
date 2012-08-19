class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable

  

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
   
  validates_uniqueness_of :email, :case_sensitive => false
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :encrypted_password, :admin

  has_one :profile, :dependent => :destroy
  has_one :job_preference, :dependent => :destroy

  has_many :favourites
  has_many :posts, :through => :favourites


  self.reset_password_within = 14.days
  


  def self.search(params)

    conditions = []
    temp = []
    parameters = []


    # search public profiles
    conditions << 'profiles.public = true'



    # Search for keyword in title and description
    if params[:keyword] && params[:keyword] != ''
      keywords = params[:keyword].split(' ')
      keywords.each do |key|
        conditions << '(lower(profiles.name) LIKE lower(?) OR 
          lower(profiles.bio) LIKE lower(?))'
        parameters << "%#{key}%"
        parameters << "%#{key}%"
      end
    end

    unless conditions.empty?
    includes(:profile).where(conditions.join(" AND "), *parameters)
    else
      scoped
    end

  end


  def self.month(num)
    if num == 1
      return "January"
    elsif num == 2
      return "February"
    elsif num == 3 
      return "March"
    elsif num == 4
      return "April"
    elsif num == 5
      return "May"
    elsif num == 6
      return "June"
    elsif num == 7
      return "July"
    elsif num == 8
      return "August"
    elsif num == 9
      return "September"
    elsif num == 10
      return "October"
    elsif num == 11
      return "November"
    elsif num == 12
      return "December"
    else return ""
    end

  end
end
