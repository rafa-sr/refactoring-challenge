# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PaymentsExportJob, :jobs do
  let(:pay_srv_mock) { instance_double 'PaymentsExportService' }

  before do
    allow(PaymentsExportService).to receive(:new).and_return(pay_srv_mock)
    allow(pay_srv_mock).to receive(:call)

    PaymentsExportJob.perform(Agent.first.id, 'foo', 'bar')
  end

  describe '#perform' do
    it 'initialize the PaymentsExportService' do
      expect(PaymentsExportService).to have_received(:new)
    end

    it 'use PaymentsExportService instance method call()' do
      expect(pay_srv_mock).to have_received(:call)
    end
  end
end
