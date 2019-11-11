module Validation
  def self.validate_postal_code(postalcode)
    regex = /^(\d{5}(-\d{4})?|[A-Za-z]\d[A-Za-z] ?\d[A-Za-z]\d)$/
    matched = postalcode.match(regex).to_s
    return true if matched == postalcode
  end
end