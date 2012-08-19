class Seeker < ActiveRecord::Base
  belongs_to :user
  has_one :position_type
  has_one :education_level

  attr_accessible :pref_email
end
