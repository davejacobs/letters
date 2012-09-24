require "active_support/core_ext/date_time/conversions"

module Letters
  Time::DATE_FORMATS[:millis] = "%m/%d/%Y %H:%M:%S:%L"
end
