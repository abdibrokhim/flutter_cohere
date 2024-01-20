# Flutter Cohere

Cohere empowers every developer and enterprise to build amazing products and capture true business value with language AI.

This package provides a powerful bridge between your Flutter application and Cohere AI. It empowers you to seamlessly integrate Cohere's capabilities into your app, unlocking possibilities for building innovative, intelligent, and engaging experiences that redefine user interaction.

## Features

- Set up your API key [scroll](#getting-started)
- Initialize Gemini [scroll](#initialize-cohere)
- Content-based APIs [scroll](#content-based-apis)
  - Stream Generate Content [scroll](#stream-generate-content)
  - Text-only input [scroll](#text-only-input)
  - Multi-turn conversations (chat) [scroll](#multi-turn-conversations-chat)
  - Embed [scroll](#embed)
  - Embed-jobs [scroll](#embed-jobs)
  - Rerank [scroll](#rerank)
  - Classify [scroll](#classify)
  - Datasets [scroll](#datasets)
  - Summarize [scroll](#summarize)
  - Tokenize [scroll](#tokenize)
  - Detokenize [scroll](#detokenize)
  - Connectors [scroll](#connectors)
- Flutter Cohere widgets [scroll](#flutter-gemini-widgets)

## Getting started

To use the Cohere API, you'll need an API key. If you don't already have one, create a key in Cohere's official website. [Get an API key](https://cohere.com/).

## Installation

Add `flutter_cohere` as a [dependency in your pubspec.yaml file](https://flutter.dev/docs/development/packages-and-plugins/using-packages).

```yaml
dependencies:
  flutter_cohere: ^0.0.1
```

## Import

Import the package into your Dart code.

```dart
import 'package:flutter_cohere/flutter_cohere.dart';
```

## Initialize Cohere

For initialization, you must call the CohereClient constructor for Flutter Cohere.

```dart
void myFunction() {

  /// Add this line
  var co = CohereClient(apiKey: '--- Your Cohere Api Key ---');

}
```

## Content-based APIs

### Text-only input

This feature lets you perform natural language processing (NLP) tasks such as text generation and completion.

```dart
  var co = CohereClient(apiKey: '--- Your Cohere Api Key ---');

co.generate(
    prompt: "Write a story about a magic backpack.",)
  .then((value) => print( value.values.first )) /// or value?.values.first
  .catchError((e) => print(e));
```

### Multi-turn conversations (chat)

Using Cohere, you can build freeform conversations across multiple turns.

```dart
    var co = CohereClient(apiKey: '--- Your Cohere Api Key ---');

  co.chat([
    {"role": "USER", "message": "Who discovered gravity?"},
    {"role": "CHATBOT", "message": "The man who is widely credited with discovering gravity is Sir Isaac Newton"}
    ])
        .then((value) => log(value.values.first ?? 'without output'))
        .catchError((e) => log('chat', error: e));
```

### Stream Generate Content
soon

### embed
soon

### embed-jobs
soon

### rerank
soon

### classify
soon

### datasets
soon

### summarize
soon

### tokenize
soon

### detokenize
soon

### connectors
soon

### Flutter Cohere widgets
soon