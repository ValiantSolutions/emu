FactoryBot.define do

  factory :integration_trello, class: Integration::Trello do
    secret { "xoxp-27327454131-27148263025-628032401494-f43eda44fc4c3ebc011017d6a45dce1b" }
    board_id { 'abcdefghj' }
    name { 'Our Awesome Test Trello' }
    token { 'abcdefghiiiii' }
  end

  factory :invalid_integration_trello, class: Integration::Trello do
    secret { "" }
    board_id { 'abcdefghj' }
    token { 'abcdefghiiiii' }
    name { 'Our Awesome Test Trello               #$#$' }
  end

end