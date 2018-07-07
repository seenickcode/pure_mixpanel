# pure_mixpanel

A pure Dart library for [Mixpanel analytics](https://www.mixpanel.com). 

## Running Tests

This library has [Flutter](http://flutter.io) as a dependency for easier testability. The tests are true end to end tests, using a real Mixpanel account and API token that anyone is free to use. I decided against mocking the API for now to keep the codebase simple.

```
flutter test test/pure_mixpanel_test.dart
```

## Features

* Event tracking

## Upcoming Features

* Storing [User Profiles](https://mixpanel.com/help/reference/http)