require 'rails_helper'

RSpec.describe Scraper::PastRaceTime do
  let(:html) do
    <<~EOS
    <td class="denma1st">
      <div class="denmaCk i0101">
        <a href="/race/result/1505021210/"><strong>東京優(GI)</strong></a> 18頭
      </div>
      (35.4 - 34.6) 33.9<br />08-08-08-07 [1人-1]<br /><strong>0.3</strong>
      <a href="/directory/horse/2012104735/">サトノラーゼン</a>
    </td>
    EOS
  end

  subject { Scraper::PastRaceTime.new(html) }

  its(:race_id) { is_expected.to eq '1505021210' }
  its(:passage_order) { is_expected.to eq '08-08-08-07' }
  its(:last_3f_time) { is_expected.to eq 33.9 }
end
