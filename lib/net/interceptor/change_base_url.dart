part of net_module;

class ChangeBaseUrlInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    if (options.extra.containsKey('OTHER_BASE_URL')) {
      options = options.copyWith(baseUrl: options.extra['OTHER_BASE_URL']);
    }
    handler.next(options);
  }
}
