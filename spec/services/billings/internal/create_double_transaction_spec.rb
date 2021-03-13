require 'rails_helper'

RSpec.describe Billings::Internal::CreateDoubleTransaction do
  subject { described_class.new.call(params) }

  let(:debitor) { create :account, external_id: 1 }
  let(:creditor) { create :account, external_id: 2 }
  let(:money_type) { create :money_type }
  let(:operation) { create :operation }
  let(:amount) { 1500 }
  let(:params) { {debitor: debitor, creditor: creditor, amount: amount, operation: operation, money_type: money_type} }

  describe 'success workflow' do
    it { is_expected.to be_success }
    it { expect { subject }.to change { Billing::Transaction.count }.by(2) }
    it { expect(subject.value_or({})[:debitor_tr]).to eql Billing::Transaction.first }
    it { expect(subject.value_or({})[:creditor_tr]).to eql Billing::Transaction.second }
    # it 'check first transaction' do
    # end
    # it 'check second transaction' do
    # end
  end

  describe 'failure workflow' do
    context 'when validate failed' do
      let(:debitor) { nil }
      it { is_expected.to be_failure }
    end

    context 'when can not save transaction' do
      context 'and save return false' do
        before { expect_any_instance_of(Billing::Transaction).to receive(:save).and_return false }
        it { is_expected.to be_failure }
        it { expect { subject }.to_not change { Billing::Transaction.count } }
      end

      context 'and save raise error' do
        before { expect_any_instance_of(Billing::Transaction).to receive(:save).and_raise ActiveRecord::RecordNotUnique, 'bbb' }
        it { is_expected.to be_failure }
        it { expect { subject }.to_not change { Billing::Transaction.count } }
      end
    end

    context 'when can not save second transaction' do
      let(:fail_stub) { object_double(Billing::Transaction.new, {save: false, errors: []}) }
      before do
        expect(Billing::Transaction).to receive(:new).once.and_call_original
        expect(Billing::Transaction).to receive(:new).once.and_return(fail_stub)
      end
      it { is_expected.to be_failure }
      it { expect { subject }.to_not change { Billing::Transaction.count } }
    end
  end
end