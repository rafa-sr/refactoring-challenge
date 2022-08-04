# frozen_string_literal: true

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

        payment_exp_srv.call
        updated_payments = payment_exp_srv.payments.pluck(:exported_at)

        updated_payments.each_with_index do |_payment, index|
          expect(updated_payments[index]).to be > outdated_payments[index]
        end
      end
    end

    describe '.create_csv_files' do
      let(:buffer) { StringIO.new }

      context 'when risk_carrier Company_1' do
        before do
          file_path = payment_exp_srv.save_path(1)
          allow(File).to receive(:open).with(file_path, 'wb').and_yield(buffer)
        end
        it 'write file using ; as colum seprator' do
          file_header = "amount;agent_id;created_at\n"
          file_body = ''
          payment_exp_srv.payments.each do |payment|
            file_body += "#{payment.amount_cents};#{payment.agent_id};#{payment.created_at}\n"
          end
          file_content = file_header + file_body

          payment_exp_srv.call

          expect(buffer.string).to eq file_content
        end
      end
      context 'when risk_carrier is not Company_1' do
        let(:payment_export) { described_class.new(Agent.first, 'Company_foo', 'my_export_type') }
        before do
          file_path = payment_export.save_path(1)
          allow(File).to receive(:open).with(file_path, 'wb').and_yield(buffer)
        end

        it 'write file  using | as colum seprator' do
          file_header = "amount|agent_id|created_at\n"
          file_body = ''
          payment_export.payments.each do |pay|
            file_body += "#{pay.amount_cents}|#{pay.agent_id}|#{pay.created_at}\n"
          end
          file_content = file_header + file_body

          payment_export.call

          expect(buffer.string).to include file_content
        end
      end
    end

    context 'private methods' do
      it 'calls .update_export_at' do
        expect(payment_exp_srv).to receive(:update_export_at)

        payment_exp_srv.call
      end

      it 'calls .create_csv_files' do
        expect(payment_exp_srv).to receive(:create_csv_files)

        payment_exp_srv.call
      end
    end
  end

  describe '.save_path' do
    it 'return tmp directory' do
      save_path = payment_exp_srv.save_path(1)

      dir = save_path.dirname.to_s.split('/').last

      expect(dir).to eql 'tmp'
    end
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

      expect(result).to include payment_exp_srv.exported_at.to_i.to_s
    end
  end

  describe '.save_export_log' do
    it 'create payment_export_log in groups of row_limit value' do
      rows_limit = payment_exp_srv.export_format.rows_limit
      groups = payment_exp_srv.payments.each_slice(rows_limit).count

      payment_exp_srv.call

      expect(PaymentExportLog.count).to be groups
    end

    it 'create payment_export_log with given agent' do
      given_agent = Agent.last

      described_class.new(given_agent, 'Company_1', 'my_export_type').call

      expect(PaymentExportLog.last.agent_id).to be given_agent.id
    end

    it 'create payment_export_log with file_name using csv_file_name' do
      payment_exp_srv.call

      file_name = PaymentExportLog.first.file_name
      expect(file_name).to eql payment_exp_srv.csv_file_name(1)
    end

    it 'create payment_export_log with created_at using Time.now' do
      time_now = Time.now
      allow(Time).to receive(:now).with(no_args).and_return(time_now)

      payment_exp_srv.call

      expect(PaymentExportLog.first.exported_at).to eql time_now
    end
  end
end

