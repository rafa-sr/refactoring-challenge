require 'rails_helper'

RSpec.describe PaymentsExportService do
  let(:payment_exp_serv) do
    described_class.new(Agent.first, 'Company_1', 'my_export_type')
  end

  describe '.call' do
    it ''
  end

  describe '.update_export_at' do
    it ''
  end

  describe '.create_csv_files' do
    it ''
  end

  describe '.save_path' do
    it ''
  end

  describe '.csv_file_name' do
    it 'return path with .csv at the end' do
      result = payment_exp_serv.csv_file_name(1)

      expect(result.chars.last(4).join).to eql '.csv'
    end
    it 'include risk_carrier on the path' do
      result = payment_exp_serv.csv_file_name(1)

      expect(result).to include payment_exp_serv.risk_carrier
    end

    it 'include export_type on the path' do
      result = payment_exp_serv.csv_file_name(1)

      expect(result).to include payment_exp_serv.export_type
    end

    it 'include the part param on the path' do
      part = 1
      result = payment_exp_serv.csv_file_name(part)

      expect(result).to include part.to_s
    end

    it 'include exported_at on the path' do
      result = payment_exp_serv.csv_file_name(1)

      expect(result).to include payment_exp_serv.exported_at.to_s
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
