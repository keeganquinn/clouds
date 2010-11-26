# Borrowing from Typo.

class String
  # Returns a-string-with-dashes when passed 'a string with dashes'.
  # All special chars are stripped in the process  
  def to_url
    return if self.nil?
    
    self.downcase.tr("\"'", '').gsub(/\W/, ' ').strip.tr_s(' ', '-').tr(' ', '-'
)
  end
end
