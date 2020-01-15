# frozen_string_literal: true

FactoryBot.define do
  factory :integration_email, class: Integration::Email do
    name { 'Test Email Integration' }
    host { 'smtp.mailtrap.io' }
    user { 'myuser' }
    password { 'mypassword' }
    port { 2525 }
    authentication { :cram_md5 }
    body_format { :plaintext }
    from { 'unittest@emu.austrailia.com' }
  end

  factory :invalid_integration_email, class: Integration::Email do
    name { }
    host { 'smtp.mailtrap.io' }
    user { 'myuser' }
    password { 'mypassword' }
    port { 'aport!' }
    authentication { :cram_md5 }
    body_format { :plaintext }
    from { 'unittest@emu.austrailia.com' }
  end
end