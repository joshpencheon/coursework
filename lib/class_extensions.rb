# Namespace for extending ruby classes.
module ClassExtensions
  
  module String
    # Matches <<Mc>>Donald, <<O'>>Reilly,
    # <<Da >>Vinci, <<De >>Havilland
    NAME_PREFIX_REGEXP = /^(mc)|(o')/i
    
    # Recursively capitalizes a name:
    #
    #    "mcdonald-o'reilly".capitalize_name
    #      # => 'McDonald-O'Reilly'
    #
    def capitalize_name
      parts = self.strip.split(/[^A-Za-z]/, 2)
      first = parts.first.send(:capitalize_name_part)
      return first if parts.length == 1
      rest = parts.last.capitalize_name
      [first, rest].join($&)
    end
    
    private 
    
    # Capitalizes a name. Called internally by String#capitalize_name.
    #
    # Examples:
    #   'mcdonald'.capitalize_name_part # => 'McDonald'
    #   'john'.capitalize_name_part     # => 'John'
    #   "o'reilly".capitalize_name_part # => "O'Reilly"
    #
    def capitalize_name_part
      if self =~ NAME_PREFIX_REGEXP
        [slice!(0, $&.length), self].map(&:capitalize).join
      else
        self.capitalize
      end
    end

  end
  
end

class String
  include ClassExtensions::String
end