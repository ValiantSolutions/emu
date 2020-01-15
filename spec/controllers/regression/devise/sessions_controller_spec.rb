require 'rails_helper'

RSpec.describe Devise::SessionsController, regressor: true, type: :controller do
  # === Routes (REST) ===
  
  # === Callbacks (Before) ===
  it { should use_before_action(:verify_signed_out_user) }
  it { should use_before_action(:allow_params_authentication!) }
  it { should use_before_action(:require_no_authentication) }
  it { should use_before_action(:assert_is_devise_resource!) }
  it { should use_before_action(:verify_authenticity_token) }
  it { should use_before_action(:authenticate_user!) }
  it { should use_before_action(:set_timezone) }
  # === Callbacks (After) ===
  it { should use_after_action(:verify_same_origin_request) }
  it { should use_after_action(:verify_authorized) }
  it { should use_after_action(:verify_policy_scoped) }
  # === Callbacks (Around) ===
  
end