# 2019_2Q_Project


excluded: # paths to ignore during linting. Takes precedence over `included`.
  - Pods
  - vendor

opt_in_rules: # some rules are only opt-in
  - force_unwrapping

identifier_name:
  min_length: # only min_length
    warning: 1
    error: 1
  excluded: # excluded via string array
    - URLRequest
    - URLResponse

function_body_length:
  warning: 50
  error: 100

type_body_length:
  warning: 300
  error: 500

file_length:
  warning: 500
  error: 1000

force_cast: warning

disabled_rules: # rule identifiers to exclude from running
  - line_length
