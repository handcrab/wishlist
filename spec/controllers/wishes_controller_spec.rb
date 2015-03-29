require 'rails_helper'

RSpec.describe WishesController, type: :controller do
  include Devise::TestHelpers

  # TODO: -> helper
  def sign_in(user = double('user'))
    if user.nil?
      allow(request.env['warden']).to receive(:authenticate!).and_throw(:warden, scope: :user)
      allow(controller).to receive(:current_user).and_return(nil)
    else
      allow(request.env['warden']).to receive(:authenticate!).and_return(user)
      allow(controller).to receive(:current_user).and_return(user)
    end
  end

  let!(:iphone) { build_stubbed :iphone }
  let!(:notebook) { build_stubbed :notebook }
  let!(:valid_wish) { iphone }

  let!(:vasia) { FactoryGirl.create :vasia } # { build_stubbed :vasia }
  let!(:ololosha) { FactoryGirl.create :ololosha }

# shared_examples 'accessible by users' do ||
#   let(:target){described_class.new}
#   it 'redirects to login page' do
#      sign_in in
#      target.make_cool
#      expect(response).to redirect_to new_user_session_path
#   end
# end
# shared_examples 'accessible by admin' do |url|
#   let(:url_path) { send(url) }
#   context 'unauthenticated' do
#     it 'redirects to root page with error' do
#       visit url_path
#       current_path.should == root_path
#       page.should have_selector('.alert-error')
#     end
#   end
# end

  #-------
  # GET
  #-------
  describe '#new' do
    # let!(:wish) { mock_model(Wish).as_new_record }
    let!(:wish) { build :wish }

    context 'authorized user' do
      before(:each) do
        # @request.env['devise.mapping'] = Devise.mappings[:user]
        # allow(request.env['warden']).to receive(:authenticate!) { user }
        sign_in vasia #
        # allow(controller).to receive(:current_user) { user }
        allow(Wish).to receive(:new).and_return wish
        # user.stub_chain(:wishes, :build).and_return wish
        get :new
      end

      it 'assigns @wish variable to the view' do
        expect(assigns[:wish]).to eq wish
      end
      it 'responds with 200' do
        expect(response).to have_http_status :success
      end
      it 'renders :new template' do
        expect(response).to render_template :new
      end
    end

    context 'non-authorized user' do
      it 'redirects to login page' do
        sign_in nil
        get :new
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  # ______
  describe '#index' do
    #     ?????
    # let!(:wishes) { [iphone, notebook] } # ?? ARelat
    # let!(:wishes) { create_list :wish, 3 }
    # let!(:iphone) { Wish.create! attributes_for :iphone }
    # let!(:wishes) { Wish.all }

    before(:each) do
      # allow(Wish).to receive(:all).and_return wishes #[valid_wish]
      Wish.stub_chain(:all, :published, :not_owned, :includes).and_return [iphone]
      get :index
    end

    it 'sends :all message to Wish class' do
      expect(Wish).to receive :all
      get :index
    end

    it 'assigns @wishes' do
      # expect(assigns[:wishes]).to match_array wishes
      expect(assigns[:wishes]).to include iphone # .not_to be_nil
    end
    it { respond_with :succes }
    it { render_template :index }
  end

  describe '#owned' do
    let!(:iphone) { build_stubbed :owned_iphone }

    context 'authorized user' do
      before(:each) do
        # @wishes = current_user.wishes.owned
        sign_in vasia
        vasia.stub_chain(:wishes, :owned).and_return [iphone]
        # Wish.stub_chain(:all, :owned).and_return [iphone]
        # allow(Wish).to receive(:all).and_return []
        get :owned
      end

      it 'sends :owned message to Wish class' do
        expect(vasia.wishes).to receive :owned
        get :owned
      end
      it 'assigns @wishes' do
        expect(assigns[:wishes]).to include iphone # .not_to be_nil
      end
      it { respond_with :succes }
      it { render_template :index }
    end

    context 'non-authorized user' do
      it 'redirects to login page' do
        sign_in nil
        get :owned
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe '#personal' do
    context 'authorized user' do
      before(:each) do
        sign_in vasia
        # allow(Wish).to receive(:all).and_return []
        allow(vasia).to receive(:wishes).and_return []
        get :personal
      end

      it 'assigns @wishes' do
        expect(assigns[:wishes]).not_to be_nil
      end
      it { respond_with :succes }
      it { render_template :index }
    end

    context 'non-authorized user' do
      it 'redirects to login page' do
        sign_in nil
        get :personal
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe '#user_public' do
    context 'user exists' do
      before(:each) do 
        get :user_public, id: vasia.id
      end
      it 'assigns @wishes' do
        expect(assigns[:wishes]).not_to be_nil
      end
      it { respond_with :succes }
      it { render_template :index }
    end

    context 'user doesnt exist' do
      it 'raises record not found' do
        expect { get :user_public, id: 'not_exists' }.to raise_exception ActiveRecord::RecordNotFound
      end
    end
  end
  # ______
  describe '#show' do
    # let(:valid_wish) { build_stubbed :iphone }
    context 'when wish is found/exists' do
      context 'access a public wish' do
        before(:each) do
          allow(Wish).to receive(:find).and_return valid_wish
          get :show, id: valid_wish.id # , valid_session
        end

        it 'assigns it to @wish' do
          expect(assigns(:wish)).to eq valid_wish
        end
        it { respond_with :success }
        it { render_template :show }
      end

      context 'access a private wish' do
        let!(:private_wish) { build_stubbed :private_wish }

        context 'authorized user/owner' do
          before(:each) do
            sign_in vasia
            allow(Wish).to receive(:find).and_return private_wish
            allow(private_wish).to receive(:user).and_return vasia
            # allow(vasia).to receive(:wishes, :find).and_return private_wish
            # vasia.stub_chain(:wishes, :find).and_return private_wish
            get :show, id: private_wish.id
          end
          it { respond_with :success }
          it { render_template :show }
        end

        context 'not owner or non-authorized user' do
          before(:each) do
            sign_in ololosha # nil
            allow(Wish).to receive(:find).and_return private_wish
            allow(private_wish).to receive(:user).and_return vasia
            # Wish.stub_chain(:published, :find) { raise ActiveRecord::RecordNotFound }
            get :show, id: private_wish.id
          end
          # it { respond_with 301 }
          it 'responds with 301' do
            expect(response).to have_http_status 301
          end
          it { redirect_to root_path }
        end
      end
    end
    # ---
    context 'when wish is not found' do
      before(:each) do
        allow(Wish).to receive(:find) { raise ActiveRecord::RecordNotFound }
        get :show, id: 'bad_id'
      end

      it { respond_with 301 } # ??? 404
      # expect(response).to redirect_to wishes_path
      it { redirect_to wishes_path }
      # it { set_flash :error }
      it 'shows an error message' do
        expect(flash[:error]).not_to be_nil
      end
    end
  end

  # ______
  describe '#edit' do
    # let!(:valid_wish) { build_stubbed :iphone }
    context 'when wish is found' do
      context 'current user is owner' do
        before(:each) do
          sign_in vasia
          allow(vasia).to receive_message_chain(:wishes, :find_by).and_return valid_wish
          # allow(iphone).to receive(:user).and_return vasia
          # allow(Wish).to receive(:find).and_return valid_wish
          get :edit, id: valid_wish.id
        end
        it 'assigns it to @wish' do
          expect(assigns[:wish]).to eq valid_wish
        end
        it { respond_with :success }
        it { render_template :edit }
      end

      context 'current user is not the owner' do
        before(:each) do
          sign_in ololosha
          # allow(Wish).to receive(:find).and_return private_wish
          # allow(private_wish).to receive(:user).and_return vasia
          allow(ololosha).to receive_message_chain(:wishes, :find_by).and_return nil
          # { raise ActiveRecord::RecordNotFound }
          get :edit, id: valid_wish.id
        end

        it 'responds with redirect' do
          expect(response).to have_http_status :redirect
          expect(response).to redirect_to root_path
        end
        # ???? it { render_template :edit }
      end
      context 'non-authorized user' do
        it 'redirects to login page' do
          sign_in nil
          get :edit, id: valid_wish.id
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
  end

  # -------
  # POST
  # -------
  describe '#create' do
    let!(:wish) { build :iphone } # new_record
    let(:wish_attributes) { wish.attributes }
    let(:post_request) { post :create, wish: wish_attributes }

    context 'authorized user' do
      before(:each) do
        sign_in vasia
        # allow(vasia).to receive_message_chain(:wishes, :build).and_return wish
        allow(Wish).to receive(:new).and_return wish
        # ???? stub strong params
        allow_any_instance_of(WishesController).to receive(:wish_params).and_return wish_attributes
      end
      it 'sends :new message to Wish class' do
        expect(Wish).to receive(:new).with wish_attributes
        post_request
      end
      it 'sends :save message to Wish model' do
        expect(wish).to receive :save
        post_request
      end
      it 'assigns it to @wish' do
        post_request
        expect(assigns[:wish]).to eq wish
      end
      # +++
      context 'with valid attributes' do
        before(:each) do
          allow(wish).to receive(:valid?).and_return true
          post_request
        end

        #  it 'saves and assigns new wish to @wish' do
        #   wish = assigns(:wish)
        #   expect(wish).to be_kind_of ActiveRecord::Base
        #   expect(wish).to be_persisted
        #   expect(wish).not_to include wish
        # end
        # it 'saves the new wish in the database' do
        #   # expect {
        #   #   post :create, wish: valid_wish
        #   # }.to change(Wish, :count).by(1)
        # end
        it { respond_with :redirect }
        it { redirect_to wish }
        it 'assigns a success flash message' do
          expect(flash[:notice]).not_to be_nil
        end
      end
      # ---
      context 'with invalid attributes' do
        before(:each) do
          allow(wish).to receive(:valid?).and_return false
          post_request
        end

        # ??? it 'does not save the new wish in the database' do
        it { respond_with 422 } # not_to be_success
        it { render_template :new }
        # re-renders the :new template
        # not empty form
        # it 'assigns error flash message' do
        #   expect(flash[:error]).not_to be_nil
        # end
      end
    end

    context 'non-authorized user' do
      it 'redirects to login page' do
        sign_in nil
        post_request
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  #-------
  # PUT
  #-------
  describe '#update' do
    let!(:old_wish) { create :iphone }
    let!(:new_wish) { attributes_for :notebook } # stub_model Wish, id: 1 }
    let(:put_request) { put :update, id: old_wish.id, wish: new_wish }

    context 'authorized user' do
      context 'user is owner' do
        before(:each) do
          sign_in vasia
          allow(vasia).to receive_message_chain(:wishes, :find_by).and_return old_wish
        end

        # it 'sends :find message to Wish class' do
        #   expect(Wish).to receive(:find).with(old_wish.id.to_s) #.and_return old_wish
        #   put_request
        # end
        it 'sends :update message to Wish model' do
          expect(old_wish).to receive(:update).with new_wish
          put_request
        end
        # re-renders the :edit template
        # not empty form
        # it {should assign_to :wish}
        it 'assigns it to @wish' do
          put_request
          expect(assigns[:wish]).to eq old_wish
        end

        # +++
        context 'with valid attributes' do
          before(:each) do
            allow(old_wish).to receive(:update).and_return true
            put_request
          end

          it { respond_with :redirect } # ??? :created
          it { redirect_to old_wish }
          it 'assigns a success flash message' do
            expect(flash[:notice]).not_to be_nil
          end
          # it 'saves updates' do
          #   expect { old_wish.reload }.to change { old_wish.title }.to(new_wish[:title])
          # end
        end
        # ---
        context 'with invalid attributes' do
          before(:each) do
            allow(old_wish).to receive(:update).and_return false
            put_request
          end
          it { respond_with 422 }
          it { render_template :edit }
          # it 'assigns error flash message' do
          #   expect(flash[:error]).not_to be_nil
          # end
        end
      end

      context 'user is not owner' do
        before(:each) do
          sign_in ololosha
          allow(ololosha).to receive_message_chain(:wishes, :find_by).and_return nil
          put_request
        end

        it 'responds with redirect' do
          expect(response).to have_http_status :redirect
          expect(response).to redirect_to root_path
        end
      end
    end

    context 'non-authorized user' do
      it 'redirects to login page' do
        sign_in nil
        put_request
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe '#toggle_public' do
    let!(:old_wish) { create :iphone }
    let(:patch_request) { patch :toggle_public, id: old_wish.id, format: :html }

    context 'user is owner' do
      before(:each) do
        sign_in vasia
        allow(vasia).to receive_message_chain(:wishes, :find_by).and_return old_wish
        allow(old_wish).to receive(:update).and_return true
      end

      it 'sends :update message to Wish model' do
        expect(old_wish).to receive(:update)
        patch_request
      end

      it { respond_with :redirect }
      it { redirect_to old_wish }
    end

    context 'user is not owner' do
      before(:each) do
        sign_in ololosha
        allow(ololosha).to receive_message_chain(:wishes, :find_by).and_return nil
        patch_request
      end

      it 'responds with redirect' do
        expect(response).to have_http_status :redirect
        expect(response).to redirect_to root_path
      end
    end

    context 'non-authorized user' do
      it 'redirects to login page' do
        sign_in nil
        patch_request
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe '#toggle_owned' do
    let!(:old_wish) { create :owned_iphone }
    let(:patch_request) { patch :toggle_owned, id: old_wish.id, format: :html }

    context 'user is owner' do
      before(:each) do
        sign_in vasia
        allow(vasia).to receive_message_chain(:wishes, :find_by).and_return old_wish
        allow(old_wish).to receive(:update).and_return true
        # allow(Wish).to receive(:find).and_return old_wish
        # allow(old_wish).to receive(:update).and_return true
        # ???? stub strong params
        allow(vasia).to receive_message_chain(:wishes, :not_owned).and_return []
        allow(vasia).to receive_message_chain(:wishes, :owned).and_return []
        request.env['HTTP_REFERER'] = personal_wishes_path
      end

      # it 'sends :find message to Wish class' do
      #   expect(Wish).to receive(:find).with(old_wish.id.to_s) #.and_return old_wish
      #   patch_request
      # end
      it 'sends :update message to Wish model' do
        expect(old_wish).to receive(:toggle_owned)
        patch_request
      end

      it 'assigns it to @wish' do
        patch_request
        expect(assigns[:wish]).to eq old_wish
      end
      # it 'assigns @wishlist' do
      #   patch_request
      #   expect(assigns[:wishlist]).not_to be_nil
      # end
      it { respond_with :redirect }
      it { redirect_to :back }
      it 'assigns a success flash message' do
        patch_request
        expect(flash[:notice]).not_to be_nil
      end

      context 'xhr request' do
        let(:patch_request) { xhr :patch, :toggle_owned, id: old_wish.id, format: :js }
        # let(:patch_request) { patch :toggle_owned, id: old_wish.id, xhr: true }

        before(:each) do
          patch_request
        end
        it 'assigns @wishes' do
          patch_request
          expect(assigns[:wishes]).not_to be_nil
        end
        it 'renders js template' do
          expect(response).to render_template :toggle_owned
        end
      end
    end

    context 'user is not owner' do
      before(:each) do
        sign_in ololosha
        allow(ololosha).to receive_message_chain(:wishes, :find_by).and_return nil
        patch_request
      end

      it 'responds with redirect' do
        expect(response).to have_http_status :redirect
        expect(response).to redirect_to root_path
      end
    end
  end

  #-------
  # DELETE
  #-------
  describe '#destroy' do
    let!(:valid_wish) { create :ram }
    let(:delete_request) { delete :destroy, id: valid_wish.id }
    let(:wish_id) { valid_wish.id }
    # let(:wish_id) { valid_wish.id.to_s }

    context 'user is owner' do
      before(:each) do
        sign_in vasia
        allow(vasia).to receive_message_chain(:wishes, :find_by).and_return valid_wish
      end

      it 'sends :destroy message to Wish model' do
        # allow(Wish).to receive(:find).with(wish_id).and_return valid_wish
        # expect(Wish).to receive(:find).with wish_id
        expect(valid_wish).to receive(:destroy)
        delete_request
      end

      # +++
      context 'when wish is found' do
        before(:each) do
          # allow(Wish).to receive(:find).with(wish_id).and_return valid_wish
          # allow(valid_wish).to receive(:destroy).and_return true
          delete_request
        end
        it { respond_with :redirect } # ??? 202
        it { redirect_to personal_wishes_path }
        # it 'destroys the requested wish' do
        #   expect { delete_request }.to change(Wish, :count).by(-1)
        #   expect(Wish.all).not_to include valid_wish
        #   # expect { valid_wish.reload }.to raise_exception ActiveRecord::RecordNotFound
        # end
      end
      # ---
      # context 'when wish is not found' do
      #   it 'raises RecordNotFound' do
      #     allow(vasia).to receive_message_chain(:wishes, :find) {nil} #{raise_error ActiveRecord::RecordNotFound}
      #     expect {delete :destroy, id: 'invalid_id'}.to raise_error ActiveRecord::RecordNotFound
      #   end
      #   # it { respond_with :not_found }
      # end
    end

    context 'user is not owner' do
      before(:each) do
        sign_in ololosha
        allow(ololosha).to receive_message_chain(:wishes, :find_by).and_return nil
        delete_request
      end
      it 'responds with redirect' do
        expect(response).to have_http_status :redirect
        expect(response).to redirect_to root_path
      end
    end
  end
end
