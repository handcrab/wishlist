require 'rails_helper'
require 'rspec/its'

RSpec.describe Wish, type: :model do
  let(:valid_attributes) { attributes_for :iphone }
  subject { Wish.create valid_attributes }

  it 'is an ActiveRecord model' do
    expect(Wish.superclass).to eq(ActiveRecord::Base)
  end

  describe 'attributes' do
    it { expect respond_to :title }
    its(:title) { is_expected.to eq valid_attributes[:title] }

    it { should respond_to :priority }
    its(:priority) { should == valid_attributes[:priority].to_i }

    it { should respond_to :price }
    its(:price) { should == valid_attributes[:price].to_f } # ???

    it { should respond_to :description }
    its(:description) { should == valid_attributes[:description] }
  end

  describe 'validations' do
    it { should validate_presence_of :title }
    it { should validate_uniqueness_of :title }

    it { should validate_numericality_of :price }
    it { should validate_numericality_of :priority }

    it 'should remove white spaces within price' do
      valid_attributes[:price] = ' 30 000'
      wish = Wish.new valid_attributes
      expect(wish).to be_valid
    end

    describe 'priority validation' do
      let(:wrong_params) { valid_attributes }

      it 'is invalid when priority is not an integer' do        
        wrong_params[:priority] = '1.5'
        wish = Wish.new wrong_params
        expect(wish).to_not be_valid

        wrong_params[:priority] = 1.5
        wish = Wish.new wrong_params
        expect(wish).to_not be_valid
      end

      it 'is invalid when priority is not between 0 to 10' do
        wrong_params[:priority] = 50
        wish = Wish.new wrong_params
        expect(wish).to_not be_valid

        wrong_params[:priority] = -1
        wish = Wish.new wrong_params
        expect(wish).to_not be_valid
      end
    end 
  end
  
  describe 'default values' do
    let(:no_priority_wish) { attributes_for :no_priority_wish }
    subject { Wish.create no_priority_wish }

    it { should be_valid }
    its(:priority) { should == 0 }
  end
end
