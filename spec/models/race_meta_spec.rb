# frozen_string_literal: true
require 'rails_helper'

RSpec.describe RaceMeta do
  let(:html) { File.read('spec/fixtures/html/race_result.html') }
  subject { RaceMeta.new(html: html) }

  its(:title) { is_expected.to eq '第83回東京優駿' }
  its(:grade) { is_expected.to eq 'GI' }
  its(:kind) { is_expected.to eq '芝' }
  its(:direction) { is_expected.to eq '左' }
  its(:distance) { is_expected.to eq '2400' }
  its(:weather) { is_expected.to eq '晴' }
  its(:condition) { is_expected.to eq '良' }
end
