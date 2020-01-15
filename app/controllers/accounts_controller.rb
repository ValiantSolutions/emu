class AccountsController < ApplicationController
  before_action :set_account, only: %i[show update destroy]
  after_action  :verify_authorized, :except => [:index]
  after_action  :verify_policy_scoped, :only => :index

  breadcrumb 'Administration', '', match: :exact

  def index
    breadcrumb 'User Accounts', '', match: :exact
    breadcrumb 'Manage Users', accounts_path, match: :exact
    @accounts = policy_scope(Account.all)
  end

  def pending
    breadcrumb 'User Accounts', '', match: :exact
    breadcrumb 'Pending Approvals', pending_accounts_path, match: :exact
    @accounts = authorize Account.where(approved: false).or(Account.where.not(locked_at: nil))
  end

  def update
    respond_to do |format|
      if account_params.key?(:locked)
        if ActiveModel::Type::Boolean.new.cast(account_params[:locked]) == true
          @account.lock_access!
        else
          @account.unlock_access!
        end
      end
      if @account.update(account_params)
        format.html { redirect_to accounts_path, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @account }
        format.js { head :ok}
      else
        format.html { redirect_to accounts_path }
        format.json { render json: @account.errors, status: :unprocessable_entity }
        format.js { head :unprocessable_entity}
      end
    end
  end

  def show
    respond_to do |format|
      unless @account == current_user
        @account.approved? ? @account.update!(approved: false) : @account.update!(approved: true)
        approval_status = @account.approved? ? 'approved' : 'unapproved'
        format.html { redirect_to accounts_path, notice: "#{@account.email} was successfully #{approval_status}." }
      else
        flash[:alert] = 'Admins cannot unapprove themselves.'
        format.html { redirect_to accounts_path }
      end
    end

  end

  def destroy
    respond_to do |format|
      unless @account == current_user
        @account.destroy
        format.html { redirect_to accounts_path, notice: "#{@account.email} was successfully deleted." }
      else
        flash[:alert] = "Admins cannot delete themselves."
        format.html { redirect_to accounts_path }
      end
      format.json { head :no_content }
    end
  end

  private

  def set_account
    @account = authorize Account.find(params[:id])
  end

  def account_params
    params.require(:account).permit(:approved, :locked, :admin)
  end
end