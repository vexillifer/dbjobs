class Post < ActiveRecord::Base

  validates :title, :presence => true

  belongs_to :poster
  has_one :poster
  belongs_to :education_level, :foreign_key => :id
  accepts_nested_attributes_for :education_level
  belongs_to :position_area, :foreign_key => :id
  belongs_to :employment_class, :foreign_key => :id
  has_many :favourites
  has_many :users, :through => :favourites

  belongs_to :address, :dependent => :delete
  accepts_nested_attributes_for :address, :allow_destroy => true

  has_attached_file :info, :content_type => { :content_type => "application/pdf" },
  :path => ":rails_root/public/assets/post_info/:id/:basename.:extension"


  # Why must I re-write the getter/setters?

  def education_level=(value)
    write_attribute(:education_level, value)
  end

  def education_level
    read_attribute(:education_level)
  end

  def position_area=(value)
    write_attribute(:position_area, value)
  end

  def position_area
    read_attribute(:position_area)
  end

  def employment_class=(value)
    write_attribute(:employment_class, value)
  end

  def employment_class
    read_attribute(:employment_class)
  end

  has_many :posting_positions, :dependent => :delete_all
  has_many :position_types, :through => :posting_positions
  accepts_nested_attributes_for :posting_positions

  attr_accessor :position_types
  after_save :update_positions

  def update_positions
    unless position_types.nil?
      position_types.each do |g|
        self.posting_positions.create(:position_type_id => g) unless g.blank?
      end
      reload
      self.position_types = nil
    end
  end


  # Select the check boxes of position types for post
  def self.c_type(params)
    @posting_positions =  Post.find(params[:id]).posting_positions
    @positions = []
    @posting_positions.each do |p|
      @positions << PositionType.find(p.position_type_id).position
    end
    return @positions
  end





  def self.search(params, addresses)
    conditions = []
    temp = []
    parameters = []

    # Select active posts
    conditions << 'status = 1'


    # Search for keyword in title and description
    if params[:keyword] && params[:keyword] != ''
      keywords = params[:keyword].split(' ')
      keywords.each do |key|
        conditions << '(lower(title) LIKE lower(?) OR 
          lower(description) LIKE lower(?))'
parameters << "%#{key}%"
parameters << "%#{key}%"
end
end



if params[:edu] && params[:edu] != 'None' && params[:edu] != ''
  conditions << "education_level >= ?"
  parameters << params[:edu]
end



    # Check start date later than specified
    if params[:start]
      conditions << "start >= ?"
      parameters << params[:start].to_date
    end

    # Create OR conditions between same attributes

    if params[:area] && params[:area] != ''
      params[:area].each do |a|
        if a == params[:area].first() && a == params[:area].last()
          temp << "position_area = ?"
        elsif a == params[:area].first()
          temp << "(position_area = ?"
        elsif a == params[:area].last()
          temp << "position_area = ?)"
else
  temp << "position_area = ?"
end
parameters << a
end
unless temp.empty?
conditions << temp.join(" OR ")
temp.clear
end
end



if params[:class] && params[:class] != ''
  params[:class].each do |e|
    if e == params[:class].first() && e == params[:class].last()
      temp << "employment_class = ?"
    elsif e == params[:class].first()
      temp << "(employment_class = ?"
    elsif e == params[:class].last()
      temp << "employment_class = ?)"
else
  temp << "employment_class = ?"
end
parameters << e
end
unless temp.empty?
conditions << temp.join(" OR ")
temp.clear
end
end



if params[:type] && params[:type] != ''
  params[:type].each do |t|
    if t == params[:type].first() && t == params[:type].last()
      temp << "position_type_id = ?"
    elsif t == params[:type].first()
      temp << "(position_type_id = ?"
    elsif t == params[:type].last()
      temp << "position_type_id = ?)"
else
  temp << "position_type_id = ?"
end
parameters << t
end
unless temp.empty?
conditions << temp.join(" OR ")
temp.clear
end
end



    # Filter through posts by address
    # TODO fix up cases (not as many are needed now)
    if addresses
      addresses.each do |a|
        if a == addresses.first() && a == addresses.last()
          temp << "(address_id = ?"
        elsif a == addresses.first()
          temp << "(address_id = ?"
        elsif a == addresses.last()
          temp << "address_id = ?"
        else
          temp << "address_id = ?"
        end
      parameters << a
    end

    # Add null option 
    unless temp.empty?
      temp << "address_id IS NULL)"
    end

unless temp.empty?
conditions << temp.join(" OR ")
temp.clear
end
end


unless conditions.empty?
  # If there are type restrictions, join
  if params[:type] && params[:type] != ''
    order('created_at DESC').joins(:posting_positions).where(conditions.join(" AND "), *parameters)
  # Else display all with includes
  else
    order('created_at DESC').includes(:posting_positions).where(conditions.join(" AND "), *parameters)
  end
else
  scoped
end

end

end
