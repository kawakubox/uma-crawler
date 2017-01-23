# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Scraper::Event do
  let(:html) { File.read('spec/fixtures/html/race_list.html') }
  let(:event) { FactoryGirl.create(:event) }
  subject { Scraper::Event.new(html: html, event: event) }

  its(:race_urls) { is_expected.to be_present }
  its('race_urls.size') { is_expected.to eq 12 }
end
