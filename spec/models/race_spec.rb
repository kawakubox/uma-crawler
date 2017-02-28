# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Race, type: :model do
  subject { FactoryGirl.build(:race) }

  it { is_expected.to respond_to :event }
  it { is_expected.to respond_to :refunds }

  its(:result_url) { is_expected.to match(%r{https://keiba.yahoo.co.jp/race/result/\d{10}/}) }
  its(:entry_url) { is_expected.to match(%r{https://keiba.yahoo.co.jp/race/denma/\d{10}/}) }
end
