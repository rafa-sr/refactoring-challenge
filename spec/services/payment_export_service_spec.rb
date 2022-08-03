require 'rails_helper'

RSpec.describe PaymentsExportService do
  let(:payment_exp_srv) do
    described_class.new(Agent.first, 'Company_1', 'my_export_type')
  end

  describe '.call' do
    let(:payments_to_exp) do
      FactoryBot.create_list(:payment, 2, amount_cents: 1_000,
                          verified: true, cancelled: false)
    end

    describe '.update_export_at' do
      it 'update the exported_at field from payments attr' do
        outdated_payments = payment_exp_srv.payments.pluck(:exported_at)

        payment_exp_srv.call()
        updated_payments = payment_exp_srv.payments.pluck(:exported_at)

        updated_payments.each_with_index do |payment, index|
          expect(updated_payments[index]).to be > outdated_payments[index]
        end
      end
    end

    describe '.create_csv_files' do
      it 'create a csv file with the payment data' do
        buffer = StringIO.new()
        file_path = payment_exp_srv.save_path(1)
        file = double('file')
        allow(File).to receive(:open).with(file_path, 'wb').and_yield(buffer)
        file_header = 'amount;agent_id;created_at' + "\n"
        file_body = ''
          payment_exp_srv.payments.each do |payment|
            file_body += "#{payment.amount_cents};#{payment.agent_id};#{payment.created_at}\n"
          end
        file_content = file_header + file_body

        payment_exp_srv.call()

        expect(buffer.string).to eq file_content
      end
    end

    context 'private methods' do
      it 'calls .update_export_at' do
        expect(payment_exp_srv).to receive(:update_export_at)

        payment_exp_srv.call()
      end

      it 'calls .create_csv_files' do
        expect(payment_exp_srv).to receive(:create_csv_files)

        payment_exp_srv.call()
      end
    end
  end


  describe '.save_path' do
    it ''
  end

  describe '.csv_file_name' do
    it 'return path with .csv at the end' do
      result = payment_exp_srv.csv_file_name(1)

      expect(result.chars.last(4).join).to eql '.csv'
    end
    it 'include risk_carrier on the path' do
      result = payment_exp_srv.csv_file_name(1)

      expect(result).to include payment_exp_srv.risk_carrier
    end

    it 'include export_type on the path' do
      result = payment_exp_srv.csv_file_name(1)

      expect(result).to include payment_exp_srv.export_type
    end

    it 'include the part param on the path' do
      part = 1
      result = payment_exp_srv.csv_file_name(part)

      expect(result).to include part.to_s
    end

    it 'include exported_at on the path' do
      result = payment_exp_srv.csv_file_name(1)

      expect(result).to include "#{payment_exp_srv.exported_at.to_i}"
    end
  end

  describe 'csv_data' do
    it ''
  end

  describe 'generate_export_csv' do
    it ''
  end

  describe 'rows_limie' do
    it ''
  end

  describe 'save_export_log' do
    it ''
  end
end
