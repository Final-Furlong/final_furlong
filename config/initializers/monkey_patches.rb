# Require all Ruby files in the core_extensions directory
Rails.root.glob("lib/core_extensions/**/*.rb").each { |f| require f }

# Apply the monkey patches
Date.prepend CoreExtensions::Date::ParseSafely
Date.prepend CoreExtensions::Date::StrptimeSafely
Date.include CoreExtensions::Date::GameTime

DateTime.prepend CoreExtensions::DateTime::ParseSafely
DateTime.include CoreExtensions::Date::GameTime

Exception.include CoreExtensions::Exception::StackTrace

Hash.include CoreExtensions::Hash::StringMerge

String.include CoreExtensions::String::MaskEmail
String.include CoreExtensions::String::NormalizeEmail
String.include CoreExtensions::String::Substrings
String.include CoreExtensions::String::ToSearchTermsArr
String.include CoreExtensions::String::UUID

