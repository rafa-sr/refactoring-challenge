# frozen_string_literal: true

class PaymentsExportService
  require 'csv'

  attr_reader :risk_carrier, :export_type, :exported_at, :payments,
              :export_format

  def initialize(agent, risk_carrier, export_type)
    @agent = agent
    @payments = Payment.ready_for_export
    @risk_carrier = risk_carrier
    @export_type = export_type
    @exported_at = Time.now
    @export_format = ExportFormat.new(risk_carrier)
  end

  def call
    ActiveRecord::Base.transaction do
      update_export_at
      create_csv_files
      save_export_log
    end
    @files
  end

  def csv_file_name(part)
    "#{@risk_carrier}_payment_#{@export_type}_#{@exported_at.to_i}_part#{part}.csv"
  end

  def save_path(part)
    Rails.root.join('tmp', csv_file_name(part))
  end

  private

  def update_export_at
    @payments.in_batches.update_all(exported_at: @exported_at)
  end

  def create_csv_files
    col_sep = @export_format.col_separator

    @files = generate_export_csv(col_sep).map.with_index(1).map do |csv, index|
      File.open(save_path(index), 'wb') { |f| f << csv }
    end
  end

  def generate_export_csv(col_sep)
    @payments.each_slice(rows_limit).map do |slice|
      CSV.generate(col_sep: col_sep) do |csv|
        csv << %w[amount agent_id created_at]
        slice.each do |payment|
          csv << csv_data(payment)
        end
      end
    end
  end

  def csv_data(payment)
    [payment.amount_cents, payment.agent.id, payment.created_at]
  end

  def rows_limit
    @export_format.rows_limit
  end

  def save_export_log
    1.upto(@payments.each_slice(rows_limit).count) do |i|
      PaymentExportLog.create(
        agent_id: @agent.id,
        file_name: csv_file_name(i),
        exported_at: Time.now
      )
    end
  end
end
