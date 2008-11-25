class Lookup
  def Lookup.add(key, value)
    @hash ||= {}
    @hash[key] = value
  end

  def Lookup.const_missing(key)
    @hash[key]
  end   

  def Lookup.each
    @hash.each {|key, value| yield(key, value)}
  end
  
  def Lookup.length
    @hash.length
  end
  
  def Lookup.values
    @hash.values || []
  end

  def Lookup.keys
    @hash.keys || []
  end
end