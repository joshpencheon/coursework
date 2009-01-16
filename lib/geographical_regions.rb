class GeographicalRegions < Lookup
  [ 'North West', 'North East', 'East Midlands', 'West Midlands',
    'York and Humberside', 'East of England', 'London', 'South Central',
    'South Coast,', 'South West' ].each { |region| self.add(region.gsub(/\s/, ''), region) }
end