part of net_module;

class HttpRequestLogInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    bool isLogRequest = options.extra[extraLogRequest];
    if (isLogRequest) {
      StringBuffer requestBuffer = StringBuffer();
      requestBuffer.write(
        '==================== REQUEST ====================\n',
      );
      requestBuffer.write('- URI: ${options.uri}\n');
      requestBuffer.write('- METHOD: ${options.method}\n');

      requestBuffer.write(
        '- HEADER:\n${options.headers.mapToStructureString()}\n',
      );

      final data = options.data;
      if (data != null) {
        if (data is Map) {
          requestBuffer.write('- BODY:\n${data.mapToStructureString()}\n');
        } else if (data is FormData) {
          final formDataMap = {}
            ..addEntries(data.fields)
            ..addEntries(data.files);

          requestBuffer.write(
            '- BODY:\n${formDataMap.mapToStructureString()}\n',
          );
        } else {
          requestBuffer.write('- BODY:\n${data.toString()}\n');
        }
      }
      requestBuffer.toString().segmentationLog();
    }
    super.onRequest(options, handler);
  }

}

class HttpResponseLogInterceptor extends Interceptor {

  @override
  void onResponse(
      Response response,
      ResponseInterceptorHandler handler,
      ) {
    bool isLogResponse = response.requestOptions.extra[extraLogResponse];
    if (isLogResponse) {
      StringBuffer responseBuffer = StringBuffer();
      responseBuffer.write(
        '==================== RESPONSE ====================\n',
      );
      responseBuffer.write('- URL:${response.requestOptions.uri}\n');

      responseBuffer.write('- HEADER:\n{\n');

      response.headers.forEach(
            (key, list) => responseBuffer.write('  "$key" : "$list",\n'),
      );

      responseBuffer.write('\n}\n');

      responseBuffer.write('''- STATUS: ${response.statusCode}\n''');

      if (response.data != null) {
        responseBuffer.write('- BODY:\n${_parseResponse(response)}\n');
      }
      responseBuffer.toString().segmentationLog();
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(
      DioException err,
      ErrorInterceptorHandler handler,
      ) {
    bool isLogResponse = err.requestOptions.extra[extraLogResponse];
    if (isLogResponse) {
      StringBuffer errorBuffer = StringBuffer();
      errorBuffer.write(
        '==================== RESPONSE-ERROR ====================\n  ',
      );
      errorBuffer.write('- URI: ${err.requestOptions.uri}\n');
      errorBuffer.write('- METHOD: ${err.requestOptions.method}\n');

      errorBuffer.write('- HEADER:\n');
      errorBuffer.write(
        '${err.response?.headers.map.mapToStructureString() ?? '空head'}\n',
      );
      errorBuffer.write('- ERROR: ${err.toString()}\n');
      errorBuffer.write('- ERROR_TYPE: ${err.type}\n');
      errorBuffer.write('- MSG: ${err.message}\n');
      errorBuffer.write('\n- STACK_TRACE:\n');
      errorBuffer.write('╔\n');
      errorBuffer.write('${err.stackTrace}\n');
      errorBuffer.write('╝\n');

      errorBuffer.toString().segmentationLog();
    }
    super.onError(err, handler);
  }

  String _parseResponse(Response response) {
    String responseStr = "";
    var data = response.data;
    if (data is Map) {
      responseStr += data.mapToStructureString();
    } else if (data is List) {
      responseStr += data.listToStructureString();
    } else {
      responseStr += data.toString();
    }

    return responseStr;
  }
}
