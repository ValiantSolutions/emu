class Integration::EmailsController < Integration::BaseController
  before_action :set_integration_email, only: [:show, :edit, :update, :destroy]
  # GET /integration/emails
  # GET /integration/emails.json
  def index
    breadcrumb 'E-mail Integrations', integration_emails_path, match: :exact

    @emails = policy_scope(Integration::Email.all)
  end

  # GET /integration/emails/1
  # GET /integration/emails/1.json
  def show
  end

  # GET /integration/emails/new
  def new
    breadcrumb 'E-mail', integration_emails_path, match: :exact
    breadcrumb 'New E-mail Integration', new_integration_email_path, match: :exact
    @email = Integration::Email.new
  end

  # GET /integration/emails/1/edit
  def edit
    breadcrumb 'E-mail', integration_emails_path, match: :exact
    breadcrumb "Edit", '', match: :exact
    breadcrumb "#{@email.name}", edit_integration_email_path(@email), match: :exact
  end

  # POST /integration/emails
  # POST /integration/emails.json
  def create
    @email = authorize Integration::Email.new(integration_email_params)
  
    respond_to do |format|
      if @email.save
        format.html { redirect_to integration_emails_path, notice: 'E-mail integration was successfully created.' }
        format.json { render :show, status: :created, location: @email }
      else
        format.html { render :new }
        format.json { render json: @email.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /integration/emails/1
  # PATCH/PUT /integration/emails/1.json
  def update
    respond_to do |format|
      if integration_email_params.key?(:to)
        @email.send_test_email(integration_email_params[:to])
        format.html { redirect_to integration_emails_path, notice: 'E-mail test message sent.' }
      elsif @email.update(integration_email_params)
        format.html { redirect_to integration_emails_path, notice: "#{@email.name} was successfully updated." }
        format.json { render :show, status: :ok, location: @email }
      else
        format.html { render :edit }
        format.json { render json: @email.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /integration/emails/1
  # DELETE /integration/emails/1.json
  def destroy
    @email.destroy
    respond_to do |format|
      format.html { redirect_to integration_emails_path, notice: "#{@email.name} was deleted successfully." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_integration_email
      @email = authorize Integration::Email.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def integration_email_params
      dirty_params = params.require(:integration_email).permit(
        :name,
        :ssl,
        :host,
        :from,
        :user,
        :password,
        :body_format,
        :to,
        :authentication,
        :port
      )
    
      if dirty_params.key?(:password) && dirty_params[:password].blank?
        dirty_params.delete :password
      end
      dirty_params
    end
end