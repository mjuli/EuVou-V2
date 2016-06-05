class Event < ActiveRecord::Base
	resourcify
  include Authority::Abilities
	
	belongs_to :user
  belongs_to :category
	
	mount_uploader :image, ImageUploader


	validates_presence_of :category
  
  def self.search(search)
    if search
      where(['lower(title) LIKE ?', "%#{search.downcase}%"])
    else
      all
    end
  end
  
  def address
    return (" #{self.number}, #{self.zip_code}, #{self.city}, #{self.country}, #{self.street}")
  end
  
end

