# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Race, type: :model do
  subject { FactoryGirl.build(:race) }

  it { is_expected.to respond_to :event }
  it { is_expected.to respond_to :refunds }

  its(:result_url) { is_expected.to match(%r{https://keiba.yahoo.co.jp/race/result/\d{10}/}) }
  its(:entry_url) { is_expected.to match(%r{https://keiba.yahoo.co.jp/race/denma/\d{10}/}) }

  describe 'before_create' do
    let(:race) { Race.new(id: 1706020711) }
    it do
      expect { race.save! }.to change { race.event_id }.from(nil).to(17060207)
    end
  end
end
