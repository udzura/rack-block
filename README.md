# rack-block

A rack middleware for controlling accesses by search bot or not, remote ip address, etc.

## Install

```bash
    $ gem install rack-block
```

No doubt it depends on `rack` (>= 1.3).

## Usage

### block all bot accesses:

```ruby
    use Rack::Block do
      bot_access do
        halt 404
      end
    end
    run App.new
```

### block all bot accesses on a specific path:

```ruby
    use Rack::Block do
      bot_access do
        path '/secret/*' do
          halt 404
        end
      end
    end
    run App.new
```

### block some patterns of accesses:

```ruby
    use Rack::Block do
      ua_pattern /googlebot/i do
        halt 404
      end
    end
    run App.new
```

### block accesses from specific IP(s):

```ruby
    use Rack::Block do
      ip_pattern '192.0.0.0' do
      # expressions like '192.0.0.' also available
        halt 404
      end
    end
    run App.new
```

### redirect accesses:

```ruby
    use Rack::Block do
      bot_access do
        path '/secret/*' do
          redirect '/'
        end
      end
    end
    run App.new
```

### redirect accesses to a double app:

```ruby
    use Rack::Block do
      bot_access do
        path '/secret/*' do
          # TheDummy is a Rack-compatible app
          double { TheDummy.new }
        end
      end
    end
    run App.new
```

More usage on RDoc: [http://rubydoc.info/github/udzura/rack-block/master/frames]

Or please look into `spec/*`

## Related Sites

* (official)[http://udzura.jp/rack-block]
* (rubygems.org)[https://rubygems.org/gems/rack-block]
* (github)[https://github.com/udzura/rack-block]
* (travis-ci)[http://travis-ci.org/udzura/rack-block] / <img src="https://secure.travis-ci.org/udzura/rack-block.png" alt="build status" />
* (author's blog)[http://blog.udzura.jp] (Japanese)

## Todo

* Make it more DRY
* More test cases
* Refactoring internal classes
* Proxying accesses to another server
* Passing IP patterns like `'192.0.0.0/24'`...

## Contributing to rack-block
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2011 Uchio Kondo <udzura@udzura.jp>. See LICENSE for
further details.
