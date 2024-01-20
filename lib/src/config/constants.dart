class Constants {
  Constants._();

  static const String cohereApiUrl = "https://api.cohere.ai";
  static const List<int> retryStatusCodes = [429, 500, 502, 503, 504];
  
  static const String apiVersion = 'v1';
  static const int cohereEmbedBatchSize = 96;
  static const String chatUrl = 'chat';
  static const String classifyUrl = 'classify';
  static const String codebookUrl = 'embed-codebook';
  static const String detectLanguageUrl = 'detect-language';
  static const String embedUrl = 'embed';
  static const String feedbackGenerateUrl = 'feedback/generate';
  static const String feedbackGeneratePreferenceUrl = 'feedback/generate/preference';
  static const String summarizeUrl = 'summarize';
  static const String generateUrl = 'generate';
  static const String rerankUrl = 'rerank';
  static const String datasetUrl = 'datasets';
  static const String connectorUrl = 'connectors';

  static const String checkApiKeyUrl = 'check-api-key';
  static const String tokenizeUrl = 'tokenize';
  static const String detokenizeUrl = 'detokenize';
  static const String loglikelihoodUrl = 'loglikelihood';

  static const String clusterJobsUrl = 'cluster-jobs';
  static const String embedJobsUrl = 'embed-jobs';
  static const String customModelUrl = 'finetune';
}
