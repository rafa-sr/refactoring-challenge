# frozen_string_literal: true

require_relative "../../config/environment"

payment_exp_srv = PaymentsExportService.new(Agent.first, 'Company_1','foo')
payment_exp_2 = PaymentsExportService.new(Agent.first, 'Company_2','foo')


Benchmark.bm do |x|
 # x.report("improve") { payment_exp_srv.improve }
 # x.report("call") { payment_exp_srv.call }
  x.report('update_export_at ') { payment_exp_srv.update_export_at }
  x.report('update_export_at_Com 2 ') { payment_exp_2.update_export_at }
#  x.report('create_csv_files') { payment_exp_srv.create_csv_files }
#  x.report('save_export_log') {payment_exp_srv.save_export_log  }
#  x.compare!
end
