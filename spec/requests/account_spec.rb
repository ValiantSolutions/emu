# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AccountsController, type: :request do
  describe 'default denies access to user accounts', type: :request do
    it do
      get accounts_path
      expect(response).to redirect_to new_user_session_url
    end
  end

  context 'normal user account' do
    before(:each) do
      login_user
    end

    describe 'factory' do
      it 'is valid' do
        @account = Account.find_by_email('mydb@user.com') || FactoryBot.create(:db_user)
        expect(@account).to be_valid
      end
    end

    describe 'GET' do
      it '#index' do
        get accounts_path
        expect(response).to have_http_status(403)
      end

      it '#pending' do
        get pending_accounts_path
        expect(response).to have_http_status(403)
      end

      it '#show' do
        @account = Account.find_by_email('mydb@user.com') || FactoryBot.create(:db_user)
        get accounts_path(@account)
        expect(response).to have_http_status(403)
      end
    end

    describe 'PUT' do
      before(:each) do
        @account = Account.find_by_email('mydb@user.com') || FactoryBot.create(:db_user)
      end
      it '#update' do
        put account_path(@account), params: {account: FactoryBot.attributes_for(:db_user, locked: true)}
        expect(response).to have_http_status(403)
        @account.reload
        expect(@account.locked).to eq(false)
      end
    end

    describe 'DELETE' do
      before(:each) do
        @account = Account.find_by_email('mydb@user.com') || FactoryBot.create(:db_user)
      end

      it '#destroy' do
        expect do
          delete account_path(@account)
        end.to change(User, :count).by(0)
        expect(response).to have_http_status(403)
      end
    end
  end

  context 'admin account' do
    before(:each) do
      login_admin
    end

    describe 'GET' do
      it '#index' do
        get accounts_path
        expect(response).to render_template(:index)
        expect(response).to have_http_status(200)
      end

      it '#pending' do
        # before(:each) do
        #   @account = Account.find_by_email('mydb@user.com') || FactoryBot.create(:db_user)
        # end
        @account = Account.find_by_email('mydb@user.com') || FactoryBot.create(:db_user)
        get pending_accounts_path(@account)
        expect(response).to render_template(:pending)
      end

      it '#show' do
        @account = Account.find_by_email('mydb@user.com') || FactoryBot.create(:db_user)
        @approved = @account.approved
        get account_path(@account)
        @account.reload
        expect(@account.approved).to eq(!@approved)
      end
    end

    describe 'PUT' do
      before(:each) do
        @account = Account.find_by_email('mydb@user.com') || FactoryBot.create(:db_user)
      end

      context 'valid attributes' do
        it 'located the model' do
          put account_path(@account), params: {account: FactoryBot.attributes_for(:db_user, locked: nil)}
          expect(assigns(:account).id).to eq @account.id
        end

        it 'changes attributes without updating the password' do
          put account_path(@account),
              params: {account: FactoryBot.attributes_for(
                :db_user, password: ' '
              )}
          @account.reload
          expect(@account.password).to_not eq(' ')
        end

        it 'unlocks the account' do
          put account_path(@account), params: {account: FactoryBot.attributes_for(:db_user), locked: false}
          @account.reload
          expect(@account.locked).to eq(false)
        end

        it 'locks the account' do
          put account_path(@account), params: {account: FactoryBot.attributes_for(:db_user, locked: true)}
          @account.reload
          expect(@account.locked).to eq(true)
        end

        it 'redirects to the index method' do
          put account_path(@account), params: {account: FactoryBot.attributes_for(:db_user)}
          expect(current_path).to redirect_to(accounts_path)
        end
      end

      context 'invalid attributes' do
        it 'does not modify the model' do
          put account_path(@account), params: {account: FactoryBot.attributes_for(:db_user, email: nil)}
          expect(assigns(:account).email).to eq @account.email
        end

        it 're-renders the index template' do
          put account_path(@account), params: {account: FactoryBot.attributes_for(:db_user, email: nil)}
          expect(current_path).to redirect_to(accounts_path)
        end
      end
    end

    describe 'DELETE' do
      before(:each) do
        @account = Account.find_by_email('mydb@user.com') || FactoryBot.create(:db_user)
      end

      it 'deletes the model' do
        expect do
          delete account_path(@account)
        end.to change(User, :count).by(-1)
      end

      it 'redirects to the index method' do
        delete account_path(@account)
        expect(current_path).to redirect_to(accounts_path)
      end
    end
  end
end