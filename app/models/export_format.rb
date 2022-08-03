class ExportFormat

  ESPECIAL_COM = 'Company_1'.freeze

  def initialize(risk_carrier)
    @risk_carrier = risk_carrier
  end

  def col_separator
    @col_separator ||= @risk_carrier ==  ESPECIAL_COM ? ';' : '|'
  end

  def rows_limit
    @rows_limit ||= @risk_carrier == ESPECIAL_COM ? 250 : 2500
  end
end
