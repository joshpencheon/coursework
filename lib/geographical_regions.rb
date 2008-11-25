class GeographicalRegions < Lookup
  [ 'North West', 'North East', 'East Midlands', 'West Midlands',
    'York and Humberside', 'East of England', 'London', 'South Central',
    'South Coast,', 'South West' ].each do |region|
    key = region.split(/ /).map(&:capitalize).join
    self.add(key, region)  
  end
end