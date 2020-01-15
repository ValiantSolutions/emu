require 'rails_helper'

RSpec.describe "integration/emails/edit", type: :view do
  before(:each) do
    @email = assign(:integration_email, FactoryBot.create(:integration_email))
  end

  it "renders the edit integration_email form" do
    render

    assert_select "form[action=?][method=?]", integration_email_path(@email), "post" do
    end
  end
end
