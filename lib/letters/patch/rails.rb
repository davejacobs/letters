require "letters/core"

begin
  Letters.patch! ActiveRecord::Base
  Letters.patch! ActionController::Base
  Letters.patch! ActionMailer::Base
rescue
  $stderr.puts "[warning] tried to patch Rails without Rails being loaded"
end
