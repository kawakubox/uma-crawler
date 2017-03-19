require 'rails_helper'

RSpec.describe Scraper::PastRaceResult do

  let(:html) do
    <<~EOS
    <td class="denma1st">
      <div class="denmaCk i0101">
        <a href="/race/result/1505021210/"><strong>東京優(GI)</strong></a> 18頭
      </div>
      5/31(東京) 芝2400<br />
      <strong>2.23.2</strong> <a href="/directory/jocky/05212/">M.デムーロ</a>(57)<br />484(-2) [7]14(1人)
    </td>
    EOS
  end

  subject { Scraper::PastRaceResult.new(html) }

  its(:race_id) { is_expected.to eq '1505021210' }
  its(:order) { is_expected.to eq 1 }
  its(:jockey_id) { is_expected.to eq '05212' }
  its(:jockey_weight) { is_expected.to eq 57.0 }
  its(:time) { is_expected.to eq '2.23.2' }
  its(:weight) { is_expected.to eq 484 }
  its(:weight_diff) { is_expected.to eq -2 }
  its(:gate_no) { is_expected.to eq 7 }
  its(:horse_no) { is_expected.to eq 14 }
  its(:popularity) { is_expected.to eq 1 }
end
