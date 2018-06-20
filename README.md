Heartwood::Service
==========

Heartwood's service object gem provides a simple DSL for working with service objects within your Rails app.

Installation
----------

Add this line to your application's Gemfile:

```ruby
gem 'heartwood-service'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install heartwood-service

Usage
----------

You can generate a new service object from the command line:

    $ bundle exec rails g heartwood:service do_stuff

`do_stuff` should be replace with the name of your service. It can be written in snake case or camel case.

This example would create an empty service object file in `app/services/do_stuff_service.rb`. That file would specify the class name for the service object, which in this case would be `DoStuffService`.

Within your app, you can call the service using the `call` class method and passing it any options (see below).

```ruby
DoStuffService.call
```

While `call` is a class method, it is mapped to pass the options to a new instance as `DoStuffService.new(options).call`. This is the point at which your options are set.

Therefore, while you should call the `call` class method on your service object, your executional code should be placed in the `call` instance method. (See below for a simple example.)

### Options

There are three types of options which we'll refer to as _attributes_:

1. Required attributes
2. Optional attributes
3. Attribute with default values

#### Required Attributes

Required attributes use the `required_attr` keyword and can accept a list of all required attributes:

```ruby
class DoStuffService < Heartwood::Service::Base
  required_attr :name, :email
end
```

You would then be required to include these attributes when calling the service.

```ruby
# This will not work:
DoStuffService.call # => ArgumentError: Missing required option: name

# Instead, do this:
DoStuffService.call(name: 'Mr. F', email: 'mrf@example.com') # => nil
```

These attributes are then available anywhere in your service as the name you specified.

```ruby
class DoStuffService < Heartwood::Service::Base
  required_attr :name, :email

  def call
    name
  end
end

# Call the service from elsewhere in your application:
DoStuffService.call(name: 'Mr. F', email: 'mrf@example.com') # => "Mr. F"
```

#### Optional Attributes

Optional attributes use the `optional_attr` method and take the same approach as required attributes, except an error won't be thrown when the attribute does not exist.

```ruby
class DoStuffService < Heartwood::Service::Base
  optional_attr :name

  def call
    name
  end
end

# Call the service from elsewhere in your application:
DoStuffService.call(name: 'Mr. F') # => nil
```

#### Attributes with Default Values

You can also have an option with a fallback value via the `attr_with_default` method.

For these attributes, you'll have to use the `attr_with_default` method for each attribute and can not chain attributes together.

```ruby
class DoStuffService < Heartwood::Service::Base
  attr_with_default :name, 'Mr. F'
  attr_with_default :email, 'mrf@example.com'

  def call
    name
  end
end

# Call the service from elsewhere in your application:
DoStuffService.call # => 'Mr F.'

# Setting the attribute would override the default:
DoStuffService.call(name: 'Mr. P') # => 'Mr. P'
```

### Example

Here's an example that would create a user. It assumes there is a `User` class that has `email`, `password`, and `name` attributes.

```ruby
class DoStuffService < Heartwood::Service::Base

  required_attr :email, :password

  optional_attr :name

  def call
    User.create(email: email, password: password, name: name)
  end
end

# Call the service from elsewhere in your application:
DoStuffService.call(email: 'mrf@example.com', password: 'password') # => #<User:0x007fb4b5ae3078>
```

Development
----------

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

Contributing
----------

Bug reports and pull requests are welcome on GitHub at https://github.com/seancdavis/heartwood-service. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

License
----------

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

Code of Conduct
----------

Everyone interacting in the Heartwood::Service project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/seancdavis/heartwood-service/blob/master/CODE_OF_CONDUCT.md).
