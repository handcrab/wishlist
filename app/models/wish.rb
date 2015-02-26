class Wish < ActiveRecord::Base  
  before_validation :strip_whitespace

  validates :title, presence: true, uniqueness: true
  validates :price, numericality: true
  validates :priority, numericality: { only_integer: true }, 
    inclusion: { in: 0..10, message: "%{value} should be between 0 and 10" }

  has_attached_file :picture, styles: { medium: "300x300>", thumb: "100x100>" } 
  #, :default_url: "/images/:style/missing.png"
  # dependent: :destroy
  validates_attachment_content_type :picture, :content_type => /\Aimage\/.*\Z/
  # validates :picture, presence: true
  
  scope :not_owned, -> { where owned: false }
  scope :owned, -> { where.not owned: false }
  scope :published, -> { where public: true}

  def toggle_owned
    self.update owned: not(owned)
  end

  protected
  def strip_whitespace
    self.price = price_before_type_cast.to_s.gsub(/\s+/, '') 
    # ???
    # if attribute_present?('price') && self.price.respond_to?(:gsub)    
    #   self.price = price_before_type_cast.gsub(/\s+/, '') 
    # end
  end
end
