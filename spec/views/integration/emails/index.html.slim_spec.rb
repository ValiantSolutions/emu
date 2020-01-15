require 'rails_helper'

RSpec.describe "integration/emails/index", type: :view do
  before(:each) do
    assign(:integration_emails, [
      FactoryBot.create(:integration_email)
    ])
  end

  it "renders a list of integration/emails" do
    render
  end
end
