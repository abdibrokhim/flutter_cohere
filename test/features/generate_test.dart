import 'dart:developer';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_cohere/flutter_cohere.dart';

void main() {

  test('Check Cohere\'s generated simple chat responding', () async {

    final co = CohereClient(apiKey: 'cohereApiKey');

    await co
        .generate(
          prompt: "Generate 2 names for my cat.",
          model: "command-light-nightly",
          maxTokens: 150,
        )
        .then((value) => log(value.values.first ?? 'without output'))
        .catchError((e) => log('generate', error: e));
  });
}