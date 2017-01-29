require 'rails_helper'

RSpec.describe Refund, type: :model do
  subject { FactoryGirl.build(:refund) }

  it { is_expected.to respond_to :race }
end
