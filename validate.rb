module Validate
  def self.postal_code?(postalcode)
    regex = /^(\d{5}(-\d{4})?|[A-Za-z]\d[A-Za-z] ?\d[A-Za-z]\d)$/
    matched = postalcode.match(regex).to_s
    matched == postalcode
  end
end