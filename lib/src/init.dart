import 'dart:convert';
import 'package:http/http.dart' as http;

import 'config/constants.dart';

class CohereClient {
/// Cohere Client
///
///    Args:
///        apiKey (String): Your API key.
///        numWorkers (int): Maximal number of threads for parallelized calls.
///        requestDict (dict): Additional parameters for calls with the requests library. Currently ignored in AsyncClient
///        checkApiKey (bool): Whether to check the api key for validity on initialization.
///        clientName (String): A string to identify your application for internal analytics purposes.
///        maxRetries (int): maximal number of retries for requests.
///        timeout (int): request timeout in seconds.
///        apiURL (String): override the default api url from the default Constants.cohereApiUrl
///        batchSize (int): maximal number of requests to send in a single batch. Only used in AsyncClient.

  final String apiKey;
  final String? apiURL;
  final int maxRetries;
  final int numWorkers;
  final dynamic requestDict;
  final bool checkApiKey;
  final int timeout;
  final String? clientName;
  final int batchSize;

  CohereClient({
    this.apiKey = "",
    String? apiURL,
    this.maxRetries = 3,
    this.numWorkers = 64,
    this.requestDict = const {},
    this.checkApiKey = true,
    this.timeout = 120,
    this.clientName,
    this.batchSize = 96,
  }) : apiURL = apiURL ?? Constants.cohereApiUrl {
    if (apiKey.isEmpty) {
      throw Exception("API key is required");
    }
    if (checkApiKey) {
      isApiKeyValid(apiKey);
    }
  }

/// [Generate] endpoint.
/// See https://docs.cohere.ai/reference/generate for advanced arguments
/// 
/// Args:
///   prompt (String): Represents the prompt or text to be completed. Trailing whitespaces will be trimmed.
///   model (String): (Optional) The model ID to use for generating the next reply.
///   returnLikelihoods (String): (Optional) One of GENERATION|ALL|NONE to specify how and if the token (log) likelihoods are returned with the response.
///   preset (String): (Optional) The ID of a custom playground preset.
///   numGenerations (int): (Optional) The number of generations that will be returned, defaults to 1.
///   maxTokens (int): (Optional) The number of tokens to predict per generation, defaults to 20.
///   temperature (double): (Optional) The degree of randomness in generations from 0.0 to 5.0, lower is less random.
///   truncate (String): (Optional) One of NONE|START|END, defaults to END. How the API handles text longer than the maximum token length.
///   stream (bool): Return streaming tokens.
///   k (int): (Optional) The number of top tokens to randomly select from.
///   p (double): (Optional) The nucleus sampling probability.
///   frequencyPenalty (double): (Optional) The frequency penalty to use for the next reply.
///   presencePenalty (double): (Optional) The presence penalty to use for the next reply.
///   endSequences (List<String>): (Optional) A list of sequences where the API will stop generating further tokens.
///   stopSequences (List<String>): (Optional) A list of sequences where the API will stop generating further tokens.
///   logitBias (Map<int, double>): (Optional) A dictionary of logit bias values to use for the next reply.
///   stream (bool): (Optional) Whether to stream back the tokens as they are generated.
/// 
/// 
/// Returns:
///   if stream=False: a Generations object
///   if stream=True: a StreamingGenerations object including:
///   id (String): The id of the whole generation call
///     generations (Generations): same as the response when stream=False
///     finish_reason (String) possible values:
///     COMPLETE: when the stream successfully completed
///     ERROR: when an error occurred during streaming
///     ERROR_TOXIC: when the stream was halted due to toxic output.
///     ERROR_LIMIT: when the context is too big to generate.
///     USER_CANCEL: when the user has closed the stream / cancelled the request
///     MAX_TOKENS: when the max tokens limit was reached.
///     texts (List<String>): list of segments of text streamed back from the API
/// 
/// Examples:
/// 
///   A simple generate message:
///     var co = CohereClient(apiKey: cohereApiKey);
///     co.generate(prompt: text, model: "command-light-nightly").then((value) {
///       var text = value['generations'][0]['text'];
///       print('text: $text');
///     });
/// 
///   Streaming generate:
///     var co = CohereClient(apiKey: cohereApiKey);
///     co.generate(prompt: text, model: "command-light-nightly", stream: true).then((value) {
///       var text = value['texts'][0];
///       print('text: $text');
///       
///       for (var value in value['tokens']) {
///         print('tokens: $value');
///       }
///     });


  Future<Map<String, dynamic>> generate({
    String? prompt,
    String? model,
    String? preset,
    int? numGenerations,
    int maxTokens = 4096,
    double temperature = 0.9,
    int k = 0,
    double? p,
    double? frequencyPenalty,
    double? presencePenalty,
    List<String>? endSequences,
    List<String> stopSequences = const [],
    String returnLikelihoods = "NONE",
    String? truncate,
    Map<int, double> logitBias = const {},
    bool stream = false,
  }) async {
    var url = Uri.parse('$apiURL/${Constants.apiVersion}/${Constants.generateUrl}');
    var body = <String, dynamic>{};
    if (model != null) body["model"] = model;
    if (prompt != null) body["prompt"] = prompt;
    if (preset != null) body["preset"] = preset;
    if (numGenerations != null) body["num_generations"] = numGenerations;
    body["max_tokens"] = maxTokens;
    body["temperature"] = temperature;
    body["k"] = k;
    body["p"] = p;
    if (frequencyPenalty != null) body["frequency_penalty"] = frequencyPenalty;
    if (presencePenalty != null) body["presence_penalty"] = presencePenalty;
    if (endSequences != null) body["end_sequences"] = endSequences;
    body["stop_sequences"] = stopSequences;
    body["return_likelihoods"] = returnLikelihoods;
    if (truncate != null) body["truncate"] = truncate;
    if (logitBias.isNotEmpty) body["logit_bias"] = logitBias;
    body["stream"] = stream;


    var response = request(
      url: url,
      json: body,
    );

    var data = await response;

      if (stream) {
        throw UnimplementedError('Stream not implemented yet.');
      } else {
        return data;
      }
    }

/// [Chat] endpoint.
/// Returns a Chat object with the query reply.
/// See https://docs.cohere.ai/reference/chat for advanced arguments
///
/// Args:
///   message (String): The message to send to the chatbot.
///
///   stream (bool): Return streaming tokens.
///   conversationId (String): (Optional) To store a conversation then create a conversation id and use it for every related request.
///
///   preambleOverride (str): (Optional) A string to override the preamble.
///   chatHistory (List<Map<String, String>>): (Optional) A list of entries used to construct the conversation. If provided, these messages will be used to build the prompt and the conversation_id will be ignored so no data will be stored to maintain state.
///
///   model (String): (Optional) The model to use for generating the response.
///   temperature (double): (Optional) The temperature to use for the response. The higher the temperature, the more random the response.
///   p (double): (Optional) The nucleus sampling probability.
///   k (double): (Optional) The top-k sampling probability.
///   logitBias (Map<int, double>): (Optional) A dictionary of logit bias values to use for the next reply.
///   maxTokens (int): (Optional) The max tokens generated for the next reply.
///
///   returnChatHistory (bool): (Optional) Whether to return the chat history.
///   returnPrompt (bool): (Optional) Whether to return the prompt.
///   returnPreamble (bool): (Optional) Whether to return the preamble.
///
///   userName (String): (Optional) A string to override the username.
///
///   searchQueriesOnly (bool) : (Optional) When true, the response will only contain a list of generated search queries, but no search will take place, and no reply from the model to the user's message will be generated.
///   documents (List<Map<String, String>>): (Optional) Documents to use to generate grounded response with citations. Example:
///   documents=[
///     {
///       "id": "national_geographic_everest",
///       "title": "Height of Mount Everest",
///       "snippet": "The height of Mount Everest is 29,035 feet",
///       "url": "https://education.nationalgeographic.org/resource/mount-everest/",
///     },
///     {
///       "id": "national_geographic_mariana",
///       "title": "Depth of the Mariana Trench",
///       "snippet": "The depth of the Mariana Trench is 36,070 feet",
///       "url": "https://www.nationalgeographic.org/activity/mariana-trench-deepest-place-earth",
///     },
///   ],
///   connectors (List<Map<String, String>>): (Optional) When specified, the model's reply will be enriched with information found by quering each of the connectors (RAG). Example: connectors: [{"id": "web-search"}]
///   citationQuality (String): (Optional) Dictates the approach taken to generating citations by allowing the user to specify whether they want "accurate" results or "fast" results. Defaults to "accurate".
///   promptTruncation (String): (Optional) Dictates how the prompt will be constructed. With `prompt_truncation` set to "AUTO", some elements from `chat_history` and `documents` will be dropped in attempt to construct a prompt that fits within the model's context length limit. With `prompt_truncation` set to "OFF", no elements will be dropped. If the sum of the inputs exceeds the model's context length limit, a `TooManyTokens` error will be returned.
/// Returns:
///   a Chat object if stream: False, or a StreamingChat object if stream: True
///
/// Examples:
///   A simple chat message:
///     var co = CohereClient(apiKey: cohereApiKey);
///     co.chat(message="Hey! How are you doing today?").then((value) {
///       print('text: $value['text']');
///     });
///
///   Continuing a session using a specific model:
///     var co = CohereClient(apiKey: cohereApiKey);
///     co.chat(
///       message="Hey! How are you doing today?",
///       conversation_id="1234",
///       model="command-light-nightly",
///       return_chat_history=True).then((value) {
///         print('text: $value['text']');
///         print('chat history: $value['chat_history']');
///     });
/// 
///   Streaming chat:
///     var co = CohereClient(apiKey: cohereApiKey);
///     co.chat(
///       message="Hey! How are you doing today?",
///       stream=True).then((value) {
///         for (var token in value.values){
///           print('token: $token');
///         }
///     });
/// 
///   Stateless chat with chat history:
///     var co = CohereClient(apiKey: cohereApiKey);
///     co.chat(
///       message="Tell me a joke!",
///       chat_history=[
///         {'role': 'User', message': 'Hey! How are you doing today?'},
///         {'role': 'Chatbot', message': 'I am doing great! How can I help you?'},
///        ],
///        return_prompt=True).then((value) {
///           print('text: $value['text']');
///           print('prompt: $value['prompt']');
///        });
/// 
///   Chat message with documents to use to generate the response:
///      var co = CohereClient(apiKey: cohereApiKey);
///      co.chat(
///          message: "How deep in the Mariana Trench",
///          documents=[
///              {
///                 "id": "national_geographic_everest",
///                 "title": "Height of Mount Everest",
///                 "snippet": "The height of Mount Everest is 29,035 feet",
///                 "url": "https://education.nationalgeographic.org/resource/mount-everest/",
///              },
///              {
///                  "id": "national_geographic_mariana",
///                  "title": "Depth of the Mariana Trench",
///                  "snippet": "The depth of the Mariana Trench is 36,070 feet",
///                  "url": "https://www.nationalgeographic.org/activity/mariana-trench-deepest-place-earth",
///              },
///            ]
///         ).then((value) {
///               print('text: ${value['text']}');
///               print('citations: ${value['citations']}');
///               print('documents: ${value['documents']}');
///        });
/// 
///   Chat message with connector to query and use the results to generate the response:
///      var co = CohereClient(apiKey: cohereApiKey);
///      co.chat(
///        message: "What is the height of Mount Everest?",
///        connectors: [{"id": "web-search"}]).then((value) {
///           print('text: ${value['text']}');
///           print('citations: ${value['citations']}');
///           print('documents: ${value['documents']}');
///        });

///   Generate search queries for fetching documents to use in chat:
///      co.chat(
///         message: "What is the height of Mount Everest?",
///         search_queries_only: True).then((value) {
///         if value['is_search_required'] {
///             print('search queries: ${value['search_queries']}');
///         }
///       });

  
  Future<Map<String, dynamic>> chat({
    String? message,
    String conversationId = "",
    String? model,
    bool returnChatHistory = false,
    bool returnPrompt = false,
    bool returnPreamble = false,
    List<Map<String, String>>? chatHistory,
    String? preambleOverride,
    String? userName,
    double temperature = 0.8,
    int maxTokens = 2048,
    bool stream = false,
    int k = 0,
    double? p,
    Map<int, double>? logitBias,
    bool searchQueriesOnly = false,
    List<Map<String, dynamic>>? documents,
    String citationQuality = "accurate",
    String promptTruncation = "AUTO",
    List<Map<String, dynamic>>? connectors,
  }) async {
    var url = Uri.parse('$apiURL/${Constants.apiVersion}/${Constants.chatUrl}');
    var body = <String, dynamic>{};
    if (model != null) body["model"] = model;
    if (message != null) body["message"] = message;
    body["conversation_id"] = conversationId;
    body["return_chat_history"] = returnChatHistory;
    body["return_prompt"] = returnPrompt;
    body["return_preamble"] = returnPreamble;
    if (chatHistory != null) body["chat_history"] = chatHistory;
    if (preambleOverride != null) body["preamble_override"] = preambleOverride;
    if (userName != null) body["user_name"] = userName;
    body["temperature"] = temperature;
    body["max_tokens"] = maxTokens;
    body["stream"] = stream;
    body["k"] = k;
    body["p"] = p;
    if (logitBias != null) body["logit_bias"] = logitBias;
    body["search_queries_only"] = searchQueriesOnly;
    if (documents != null) body["documents"] = documents;
    body["citation_quality"] = citationQuality;
    body["prompt_truncation"] = promptTruncation;
    if (connectors != null) body["connectors"] = connectors;

    var response = request(
      url: url,
      json: body,
    );

    var data = await response;

      if (stream) {
        throw UnimplementedError('Stream not implemented yet.');
      } else {
        return data;
      }
  }


  Future<Map<String, dynamic>> request({
    required Uri url,
    String method = 'POST',
    Map<String, String>? headers,
    Map<String, dynamic>? json,
}) async {
  var client = http.Client();
  http.Response response;

  try {
    headers ??= {};
    headers['Authorization'] = 'Bearer $apiKey';
    headers['Content-Type'] = 'application/json';

    if (method == 'POST') {
      response = await client.post(url, headers: headers, body: jsonEncode(json));
    } else if (method == 'GET') {
      response = await client.get(url, headers: headers);
    } else {
      throw UnimplementedError('HTTP method $method not implemented.');
    }

    if (response.statusCode != 200) {
      throw Exception('Request failed with status ${response.statusCode}');
    }

    return jsonDecode(response.body);
  } catch (e) {
    throw Exception('Request failed with error $e');
  } finally {
    client.close();
  }
}

}

bool isApiKeyValid(String key) {
///        Checks the api key, which happens automatically during Client initialization, but not in AsyncClient.
///        check_api_key raises an exception when the key is invalid, but the return value for valid keys is kept for
///        backwards compatibility.
/// 
///        isApiKeyValid returns True when the key is valid and raises a CohereError when it is invalid.
  if (key.isEmpty) {
    throw Exception(
        "No API key provided. Provide the API key in the client initialization.");
  }
  return true;
}
