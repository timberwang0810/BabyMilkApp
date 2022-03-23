Labelary.configure do |config|
  config.dpmm   = 8 # required
  config.width  = 3.98 # required (inches)
  config.height = 6.85 # required (inches)
  config.index = 0 # optional, for picking a label when multiple are present in the ZPL (usually 0)
  config.content_type = 'image/png' # or 'application/pdf', specifies the content type of the returned label
end