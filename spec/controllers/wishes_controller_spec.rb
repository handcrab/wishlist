require 'rails_helper'

RSpec.describe WishesController, type: :controller do
  let!(:wish) { mock_model(Wish).as_new_record }
    
  describe "GET #new" do      
    before(:each) do       
      allow(Wish).to receive(:new).and_return wish
      # allow(MyMod::Utils).to receive(:find_x).and_return({something: 'testing'})
      get :new #=> assigns  
    end

    it 'assigns a new Wish variable to the view' do            
      expect(assigns[:wish]).to eq wish
    end

    it "renders the :new template" do                
      expect(response).to have_http_status :success
      expect(response).to render_template :new
    end
  end

  # __________
  describe "GET #index" do 
    before(:each) do
      get :index
    end

    it "populates an array of wishes" do
      expect(assigns[:wishes]).not_to be_nil #eq wish
    end
    
    it "renders the :index view" do
      expect(response).to have_http_status :success
      expect(response).to render_template :index
    end
  end 

  # _________
  describe "GET #show" do 
    let(:valid_wish) { FactoryGirl.create :valid_wish }      

    before(:each) do       
      allow(Wish).to receive(:new).and_return valid_wish
      # allow(MyMod::Utils).to receive(:find_x).and_return({something: 'testing'})
      get :show, {id: valid_wish.to_param} #, valid_session  
    end

    it "assigns the requested wish to @wish" do                
      expect(assigns(:wish)).to eq valid_wish
    end

    it "renders the :show template" do 
      expect(response).to render_template :show
    end

    describe 'access to nonexistent wish' do
      before(:each) do
        allow(Wish).to receive(:find) { raise ActiveRecord::RecordNotFound }
        invalid_id = 42
        get :show, id: invalid_id
      end
      it 'should redirect to :index page' do
        expect(response).to have_http_status 301
        expect(response).to redirect_to wishes_path
      end

      it 'should show an error message' do
        expect(flash[:error]).not_to be_nil
      end
    end
  end 

  # ______________
  describe "POST #create" do 
    let!(:wish) { stub_model Wish }     

    before(:each) do
      # invalid_wish = FactoryGirl.build :invalid_wish 
      # allow(invalid_wish).to receive(:save).and_return true       
      allow(Wish).to receive(:new).and_return(wish)      
      # ???? stub strong params
      allow_any_instance_of(WishesController).to receive(:wish_params).and_return wish.attributes         
    end

    it 'sends :new message to Wish class' do
      expect(Wish).to receive(:new).with wish.attributes
      post :create, wish: wish.attributes
    end

    it 'sends :save message to Wish model' do
      expect(wish).to receive :save
      post :create, wish: wish.attributes
    end

    # +++
    context "with valid attributes" do 
      let!(:valid_wish) { FactoryGirl.create :valid_wish }

      before(:each) do
        allow(wish).to receive(:valid?).and_return true 
        post :create, wish:  @params # wish.attributes          
      end

      # it "saves the new wish in the database" do
      #   # expect {
      #   #   post :create, wish: valid_wish
      #   # }.to change(Wish, :count).by(1)              
      # end

      it "redirects to the wish page" do
        expect(response).to have_http_status :redirect #??? :created
        expect(response).to redirect_to wish
      end

      it 'assigns a success flash message' do
        expect(flash[:notice]).not_to be_nil
      end
    end 


    # ----
    context "with invalid attributes" do 
      before(:each) do
        allow(wish).to receive(:valid?).and_return false
        post :create, wish: wish.attributes         
      end

      # ??? it "does not save the new wish in the database" do 
      it "re-renders the :new template" do 
        expect(response).to have_http_status 422                                
        expect(response).to render_template :new
      end

      # not empty form
      it 'assigns wish variable to the View' do        
        expect(assigns[:wish]).to eq(wish)
      end

      # it 'assigns error flash message' do
      #   expect(flash[:error]).not_to be_nil
      # end      
    end 
  end

end
