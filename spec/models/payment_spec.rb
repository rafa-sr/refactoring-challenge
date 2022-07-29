# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Payment, type: :model do
  describe '.ready_for_export' do
    it 'not return unverified and cancel payments' do
      payment = FactoryBot.create(:payment, verified: false, cancelled: false)

      expect(Payment.ready_for_export).not_to include payment
    end
    it 'not return cancelled payments' do
      cancelled_payment = FactoryBot.create(:payment, verified: true, cancelled: true)

      expect(Payment.ready_for_export).not_to include cancelled_payment
    end

    it 'return only verified and not cancelled payments' do
      export_payment = FactoryBot.create(:payment, verified: true, cancelled: false)

      expect(Payment.ready_for_export).to include export_payment
    end

    it 'not return un verified payments' do
      unverified_payment = FactoryBot.create(:payment, verified: false, cancelled: false)

      expect(Payment.ready_for_export).not_to include unverified_payment
    end
  end
end
