require 'rails_helper'

describe CookieBakerWorker do
  subject { described_class }

  it { is_expected.to be_retryable false }

  describe 'perform' do
    context 'when the given cookie does not exist' do
      it 'does not break' do
        expect { subject.new.perform(1) }.not_to raise_error
      end
    end

    context 'when the given cookie exists' do
      let!(:cookie) { FactoryGirl.create(:cookie, ready: is_ready) }

      context 'when cookie is ready' do
        let(:is_ready) { true }

        it 'does nothing' do
          expect(cookie).to be_ready
          subject.new.perform(cookie.id)
          expect(cookie).to be_ready
        end
      end

      context 'when cookie is not ready' do
        let(:is_ready) { false }

        it 'bakes cookie' do
          expect(cookie).not_to be_ready
          subject.new.perform(cookie.id)
          expect(cookie.reload).to be_ready
        end
      end
    end
  end

  describe 'perform_async' do
    let(:some_cookie_id) { 123 }

    it 'enqueues job properly' do
      subject.perform_async(some_cookie_id)

      expect(subject).to have_enqueued_sidekiq_job(some_cookie_id)
    end
  end
end
