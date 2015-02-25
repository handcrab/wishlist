class Wish < ActiveRecord::Base  
  before_validation :strip_whitespace

  validates :title, presence: true, uniqueness: true
  validates :price, numericality: true
  validates :priority, numericality: { only_integer: true }, 
    inclusion: { in: 0..10, message: "%{value} should be between 0 and 10" }

  scope :not_owned, -> { where owned: false }
  scope :owned, -> { where.not owned: false }

  protected
  def strip_whitespace
    self.price = price_before_type_cast.to_s.gsub(/\s+/, '') 
    # ???
    # if attribute_present?('price') && self.price.respond_to?(:gsub)    
    #   self.price = price_before_type_cast.gsub(/\s+/, '') 
    # end
  end
end
