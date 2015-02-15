class Wish < ActiveRecord::Base
  before_validation :strip_whitespace

  validates :title, presence: true, uniqueness: true
  validates :price, numericality: true
  validates :priority, numericality: { only_integer: true }, 
    inclusion: { in: 0..10, message: "%{value} should be between 0 and 10" }

  protected
  def strip_whitespace
    self.price = price_before_type_cast.gsub(/\s+/, '') if attribute_present?('price')
  end
end
