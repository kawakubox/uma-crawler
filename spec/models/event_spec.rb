# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Event do
  subject { FactoryGirl.build(:event) }

  it { is_expected.to respond_to :held_on }
  it { is_expected.to respond_to :races }

  its(:url) { is_expected.to match(%r{https://keiba.yahoo.co.jp/race/list/\d{8}/}) }
end
