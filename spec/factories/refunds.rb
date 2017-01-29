FactoryGirl.define do
  factory :refund do
    race
    bet_type '単勝'
    winning_number '7'
    payout 1_230
  end
end
