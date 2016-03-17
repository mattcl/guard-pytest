# Guard::Pytest
[![Gem Version](https://badge.fury.io/rb/guard-pytest.svg)](http://badge.fury.io/rb/guard-pytest)
[![Build Status](https://secure.travis-ci.org/kazufusa/guard-pytest.png?branch=master)](http://travis-ci.org/kazufusa/guard-pytest)
[![Dependency Status](https://gemnasium.com/kazufusa/guard-pytest.svg)](https://gemnasium.com/kazufusa/guard-pytest)

Guard for [Pytest](http://pytest.org/latest/).

## Installation

Make sure you have installed pytest.

Add this line to your application's Gemfile:

    gem 'guard-pytest'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install guard-pytest

## Usage

```ruby
guard :pytest, pytest_option: '--doctest-modules --color=yes' do
  watch(%r{^((?!test/).*)\.py$})  {|m| "test/#{m[1]}_test.py" }
  watch(%r{^test/.*_test\.py$})
end
```

Other options:

```ruby
run_all_option; '--foo'  # options to be used when running all tests, default to pytest_option
all_after_pass: true     # run all tests after a changed file passes, default: false
remove_pyc: true         # remove pyc files when running all tests, default: false
pyc_dirs: ['foo', 'bar'] # directories relative to where guard is invoked
                         # .pyc files in these directories will be removed.
                         # if not specified, all .pyc files under current dir
                         # will be removed.
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kazufusa/guard-pytest. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

