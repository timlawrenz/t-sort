# frozen_string_literal: true

RSpec.describe Items::MakeBiggerJob, type: :job do
  describe '#perform' do
    subject(:perform) { described_class.perform_now(item1_id: 1, item2_id: 2) }

    it 'does something' do
      expect { perform }.to change(Relation, :count).by(1)
    end
  end
end
