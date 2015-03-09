require 'rails_helper'
require 'rspec/its'

RSpec.describe User, type: :model do  
  let(:user_attributes) { attributes_for :vasia }
  subject { User.create! user_attributes }

  describe 'attributes' do
    it { expect respond_to :name }
    its(:name) { is_expected.to eq user_attributes[:name] }
  end

  describe '#display name' do
    it { expect respond_to :display_name }
    context 'user set no name' do
      it 'generates display name from email' do
        ololosha = User.create! attributes_for :ololosha
        # its(:display_name) { is_expected.to eq 'ololosha' }
        expect(ololosha.display_name).to eq 'ololosha'
      end
    end
    context 'user has name' do
      it 'returns name' do
        ololosha = User.create! attributes_for :ololosha
        new_name = 'Олег Сергеевич'
        ololosha.update name: new_name

        expect(ololosha.display_name).to eq new_name
      end
    end
  end

  describe 'wish relation' do
    it { should have_many(:wishes).dependent(:destroy) }
  end
end
