Labelary.configure do |config|
  config.dpmm   = 12 # required
  config.width  = 3 # required (inches)
  config.height = 2 # required (inches)
  config.index = 0 # optional, for picking a label when multiple are present in the ZPL (usually 0)
  config.content_type = 'image/png' # or 'application/pdf', specifies the content type of the returned label
  config.url = 'http://api.labelary.com' # optional (for self hosted)
end