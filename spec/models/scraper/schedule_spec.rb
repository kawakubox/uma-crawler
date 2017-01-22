# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Scraper::Schedule do
  let(:html) { File.read('spec/fixtures/html/schedule_list.html') }
  subject { Scraper::Schedule.new(html: html) }

  its(:event_urls) { is_expected.to be_present }
  its('event_urls.size') { is_expected.to eq 24 }
end
