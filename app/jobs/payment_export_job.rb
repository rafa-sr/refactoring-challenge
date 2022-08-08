class PaymentExportJob
  @queue = :payments_export

  def self.perform(agent_id, risk_carrier, export_type)
    agent = Agent.find(agent_id)
    PaymentsExportService.new(agent, risk_carrier, export_type).call
  end
end
