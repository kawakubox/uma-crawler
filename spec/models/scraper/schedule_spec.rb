# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Scraper::Schedule do
  let(:html) { File.read('spec/fixtures/html/schedule_list.html') }
  subject { Scraper::Schedule.new(html: html) }

  its(:year) { is_expected.to eq 2010 }
  its(:month) { is_expected.to eq 1 }

  describe :events do
    it 'creates some events' do
      expect { subject.events }.to change { Event.count }.from(0).to(24)
    end
  end
end
