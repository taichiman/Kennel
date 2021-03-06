class Album < ActiveRecord::Base
  has_one :post
  has_many :pets, :through => :photos, :uniq => true
  has_and_belongs_to_many :photos, :uniq => true

  accepts_nested_attributes_for :photos, :allow_destroy => true

  validates :name, :presence => true
  validates :description, :length => {:maximum => 500}

  scope :event, where('post_id != 0')
  scope :hidden, where(:hidden => true)
  scope :visible, where(:hidden => false)

  def assign_pets(pet_ids)
    if pet_ids
      pets = Pet.find(pet_ids)
      photos.each do |photo|
        photo.pets << pets
      end
    end
  end

  def assign_photos(photo_ids)
    if photo_ids
      photos << Photo.find(photo_ids)
    end
  end

end
