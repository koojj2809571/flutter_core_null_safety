part of net_module;

class HttpUtil {
  static HttpUtil? _instance;

  static late String _initBaseUrl;

  static Dio? _dio;

  static final Map<String, CancelToken> _cancelTokens = <String, CancelToken>{};

  late HttpController _controller;

  ///第一次初始化baseUrl不能为空
  ///之后调用构造函数获取单例时，传入baseUrl会改变baseURL，要重置为初始化url调用[resetInitUrl]
  ///如果请求时临时改变url在调用[get][post]时，传入tempChangeUrl
  factory HttpUtil({
    String? baseUrl,
    int? cTimeout,
    int? rTimeout,
    Map<String, dynamic>? headers,
    String? cType,
    ResponseType? rType,
    Interceptor? responseOuterInterceptor,
    bool isLog = true,
    List<Interceptor>? interceptors,
  }) {
    if (_instance == null && baseUrl == null) {
      throw Exception('初始化HttpUtil未配置baseUrl');
    }

    if (_instance == null && baseUrl != null) {
      _initBaseUrl = baseUrl;
      _instance = HttpUtil._internal(
        baseUrl,
        cTimeout,
        rTimeout,
        headers,
        cType,
        rType,
        responseOuterInterceptor,
        isLog,
        interceptors,
      );
    }

    assert(_instance == null, 'HttpUtil实例为null');
    if (baseUrl != null) return _baseUrl(baseUrl);
    return _instance!;
  }

  //用于指定特定域名
  static HttpUtil _baseUrl(String baseUrl) {
    if (_dio != null) {
      _dio!.options.baseUrl = baseUrl;
    }
    return _instance!;
  }

  HttpUtil._internal(
    String baseUrl,
    int? cTimeout,
    int? rTimeout,
    Map<String, dynamic>? headers,
    String? cType,
    ResponseType? rType,
    Interceptor? responseOuterInterceptor,
    bool isLog,
    List<Interceptor>? interceptors,
  ) {
    _controller = HttpController();
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: cTimeout,
      receiveTimeout: rTimeout,
      headers: headers,
      contentType: cType,
      responseType: rType,
    );

    _dio = Dio(options);

    if (responseOuterInterceptor != null) {
      _dio!.interceptors.add(responseOuterInterceptor);
    }

    _dio!.interceptors.add(ConnectionStatusInterceptor(_controller));

    if (isLog) {
      _dio!.interceptors.add(HttpLogInterceptor());
    }

    _dio!.interceptors.add(ChangeBaseUrlInterceptor());

    if (interceptors != null && interceptors.isNotEmpty) {
      _dio!.interceptors.addAll(interceptors);
    }
  }

  /// 重置默认url,默认url为初始化单例时传入BaseUrl
  void resetInitUrl() {
    assert(_instance != null, 'HttpUtil实例为null');
    assert(_dio != null, 'Dio实例为null');
    if (_instance == null || _dio == null) return;
    _dio!.options.baseUrl = _initBaseUrl;
  }

  HttpController httpController() => _controller;

  void cancelRequest(String tokenName) {
    tokenName = tokenName.split('(')[0];
    _cancelTokens[tokenName]?.cancel("cancelled");
  }

  void removeCancelToken(BuildContext context) {
    _cancelTokens.remove(_getCancelToken(context));
  }

  CancelToken? _getCancelToken(BuildContext context) {
    CancelToken? cancelToken;
    String cancelTokenKey = context.toString().split('(')[0];
    if (!_cancelTokens.containsKey(cancelTokenKey)) {
      cancelToken = CancelToken();
      _cancelTokens[cancelTokenKey] = cancelToken;
    } else {
      cancelToken = _cancelTokens[cancelTokenKey];
    }
    return cancelToken;
  }

  Future _request(
    String method,
    BuildContext context,
    Options options,
    String path, {
    dynamic params,
    String? tempChangeUrl,
    required bool isLogRequest,
    required bool isLogResponse,
    required bool isRefresh,
    required bool isCache,
  }) async {
    Options requestOptions = options;
    requestOptions = requestOptions.copyWith(
      method: method,
      extra: {
        "context": context,
        if (!tempChangeUrl.blank) "OTHER_BASE_URL": tempChangeUrl,
        extraLogRequest: isLogRequest,
        extraLogResponse: isLogResponse,
        extraRefresh: isRefresh,
        extraCache: isCache,
      },
    );
    var response = await _dio!.request(
      path,
      queryParameters: method == 'GET' ? params : null,
      data: method == 'POST' ? params : null,
      options: requestOptions,
    );
    return response.data;
  }

  /// restful get 操作
  /// 如果请求时临时改变url在调用时，传入tempChangeUrl
  Future get(
    BuildContext context,
    String path, {
    dynamic params,
    String? tempChangeUrl,
    Options? options,
    bool isLogRequest = false,
    bool isLogResponse = false,
    bool isRefresh = false,
    bool isCache = false,
  }) async {
    Options requestOptions = options ?? Options();
    return _request(
      'GET',
      context,
      requestOptions,
      path,
      tempChangeUrl: tempChangeUrl,
      params: params,
      isLogRequest: isLogRequest,
      isLogResponse: isLogResponse,
      isCache: isCache,
      isRefresh: isRefresh,
    );
  }

  /// restful post 操作
  /// 如果请求时临时改变url在调用时，传入tempChangeUrl
  Future post(
    BuildContext context,
    String path, {
    dynamic params,
    String? tempChangeUrl,
    Options? options,
    bool isLogRequest = false,
    bool isLogResponse = false,
    bool isRefresh = false,
    bool isCache = false,
  }) async {
    Options requestOptions = options ?? Options();
    return _request(
      'POST',
      context,
      requestOptions,
      path,
      tempChangeUrl: tempChangeUrl,
      params: params,
      isLogRequest: isLogRequest,
      isLogResponse: isLogResponse,
      isCache: isCache,
      isRefresh: isRefresh,
    );
  }
}
