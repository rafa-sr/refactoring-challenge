class PaymentsExportService
  require "csv"
  require 'ruby-prof'

  attr_reader :risk_carrier, :export_type, :exported_at, :payments

  def initialize(agent, risk_carrier, export_type)
    @agent = agent
    @payments = Payment.ready_for_export
    @risk_carrier = risk_carrier
    @export_type = export_type
  end

  def call
    @exported_at = Time.now
    ActiveRecord::Base.transaction do
      RubyProf.start
      update_export_at

      create_csv_files
      save_export_log
      result = RubyProf.stop
      printer = RubyProf::GraphHtmlPrinter.new(result)
      report_file = File.new( Rails.root.join("tmp","report_company_2_#{Time.now}_.html"), 'wb' )
      puts "REPORT:   #{report_file.path}"
      printer.print(report_file, min_percent: 1)
    end
    @files
  end

private

  def update_export_at
    @payments.each do |p|
      p.update(exported_at: @exported_at)
    end
  end

  def create_csv_files
    col_sep = @risk_carrier == "Company_1" ? ";" : "|"

    @files = csv_data(col_sep).map.with_index(1).map do |csv, index|
      File.open(save_path(index), "wb") { |f| f << csv }
    end
  end

  def generate_export_csv(col_sep)
    @payments.each_slice(rows_limit).map do |slice|
      CSV.generate(col_sep: col_sep) do |csv|
        csv << ["amount", "agent_id", "created_at"]
        slice.each do |payment|
          csv << csv_data(payment) if !payment.processed?
        end
      end
    end
  end

  def csv_data(payment)
    [payment.amount_cents, payment.agent.id, payment.created_at]
  end

  def rows_limit
    @risk_carrier == "Company_1" ? 250 : 2500
  end

  def save_path(part)
    Rails.root.join("tmp", csv_file_name(part))
  end

  def csv_file_name(part)
    "#{@risk_carrier}_payment_#{@export_type}_#{@exported_at.to_i}_part#{part}.csv"
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
