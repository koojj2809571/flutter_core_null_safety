part of net_module;

class ConnectionStatusInterceptor extends Interceptor {
  final HttpController _controller;

  ConnectionStatusInterceptor(this._controller);

  @override
  Future onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    _controller.startLoading();
    handler.next(options);
  }

  @override
  Future onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    _controller.stopLoading();
    _controller.onError(err);
    handler.next(err);
  }

  @override
  Future onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    _controller.stopLoading();
    _controller.onSuccess();
    handler.next(response);
  }
}
