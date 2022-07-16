# Require all Ruby files in the core_extensions directory
Dir[Rails.root.join("lib/core_extensions/**/*.rb")].each { |f| require f }

# Apply the monkey patches
Date.include CoreExtensions::Date::ParseSafely
Date.include CoreExtensions::Date::StrptimeSafely

DateTime.include CoreExtensions::DateTime::ParseSafely

Exception.include CoreExtensions::Exception::StackTrace

Hash.include CoreExtensions::Hash::StringMerge

String.include CoreExtensions::String::MaskEmail
String.include CoreExtensions::String::NormalizeEmail
String.include CoreExtensions::String::Substrings
String.include CoreExtensions::String::ToSearchTermsArr
