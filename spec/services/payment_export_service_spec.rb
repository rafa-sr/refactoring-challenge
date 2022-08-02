require 'rails_helper'

RSpec.describe PaymentsExportService do
  let(:payment_exp_srv) do
    described_class.new(Agent.first, 'Company_1', 'my_export_type')
  end

  describe '.call' do
    let(:payments_to_exp) do
      FactoryBot.create_list(:payment, 2,
                          verified: true, cancelled: false)
    end

    describe '.update_export_at' do
      it 'update the exported_at field from payments attr' do
        olds_exported_at = payments_to_exp.pluck(:exported_at)
        payments = payment_exp_srv.payments

        payment_exp_srv.call()

        payment_ready_to_exp.each_with_index do |payment, index|
          expect(payments[index].exported_at).not_to eql olds_exported_at[index]
        end
      end
    end

    describe '.create_csv_files' do
      it '' do

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

      expect(result).to include payment_exp_srv.exported_at.to_s
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
