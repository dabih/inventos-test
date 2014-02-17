class Kvstorage < ActiveRecord::Base
  attr_accessible :key, :value, :rating

  validates :key, presence: true, uniqueness: true, length: { maximum: 100 }
  validates_format_of :key, :with => /^[A-Za-z0-9._]*\z/
  validates :value, length: { maximum: 100 }
  
end
