require 'rails_helper'

RSpec.describe Billings::CreateOperation do
  subject { described_class.new.call(params) }

  let(:reason) { :test_reason }
  let(:run_at) { DateTime.current - 2.days }
  let(:subject_entity) { create :account }
  let(:params) { {reason: reason, run_at: run_at, subject: subject_entity} }

  describe 'success workflow' do
    it { is_expected.to be_success }
    it { expect { subject }.to change { Billing::Operation.count }.by(1) }
    it 'fill all fields' do
      res = subject.value_or({})
      expect(res[:subject_id]).to eql subject_entity.id # TODO: Change to check polimorph link
      expect(res[:subject_type]).to eql subject_entity.class.to_s
      expect(res[:reason]).to eql reason
      expect(res[:run_at]).to eql run_at
    end
  end

  describe 'failure workflow' do
    context 'when validate failed' do
      let(:reason) { nil }
      it { is_expected.to be_failure }
    end

    context 'when can not save operation' do
      context 'and save return false' do
        before { expect_any_instance_of(Billing::Operation).to receive(:save).and_return false }
        it { is_expected.to be_failure }
        it { expect { subject }.to_not change { Billing::Operation.count } }
      end

      context 'and save raise error' do
        before { expect_any_instance_of(Billing::Operation).to receive(:save).and_raise ActiveRecord::RecordNotUnique, 'bbb' }
        it { is_expected.to be_failure }
        it { expect { subject }.to_not change { Billing::Operation.count } }
      end
    end
  end
end