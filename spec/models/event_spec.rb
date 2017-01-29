# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Event do
  subject { FactoryGirl.build(:event) }

  its(:url) { is_expected.to match(%r{http://keiba.yahoo.co.jp/race/list/\d{8}/}) }
  it { is_expected.to respond_to :held_on }
  it { is_expected.to respond_to :races }

end
