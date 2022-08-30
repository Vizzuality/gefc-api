# spec/support/custom_matchers/json_matchers.rb
RSpec::Matchers.define :look_like_json do |expected|
  match do |actual|
    JSON.parse(actual)
  rescue JSON::ParserError
    false
  end

  failure_message do |actual|
    "\"#{actual}\" is not parsable by JSON.parse"
  end

  description do
    "Expects to be JSON parsable String"
  end
end
