<a href="https://rubygems.org/gems/low_event" title="Install gem"><img src="https://badge.fury.io/rb/low_event.svg" alt="Gem version" height="18"></a>

# LowEvent

LowEvent formalises an event-driven architecture with easy to understand events.

## Creating Events

Inherit from `LowEvent` or use one of the events defined by LowEvent.

### ResponseEvent

```ruby
response = Low::Events::ResponseFactory.response(body: 'HTML/JSON')
Low::Events::ResponseEvent.new(response:)
```
