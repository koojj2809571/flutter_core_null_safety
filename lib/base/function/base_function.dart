part of base_module;

mixin class BaseFunction {
  State? _stateBaseFunction;
  BuildContext? _contextBaseFunction;

  bool _isErrorWidgetShow = false;

  String _errorContentMessage = "网络错误啦~~~";

  String _errImgPath = GlobalConstant().errorBg;

  bool isLoadingWidgetShow = false;

  bool _isEmptyWidgetVisible = false;

  String _emptyWidgetContent = "暂无数据~";

  String _emptyImgPath = GlobalConstant().emptyDataBg;

  final FontWeight _fontWidget = FontWeight.w600; //错误页面和空页面的字体粗度

  double bottomVertical = 0; //作为内部页面距离底部的高度

  Widget _getBaseErrorWidget() => getErrorWidget();

  Widget _getBassLoadingWidget() => getLoadingWidget();

  Widget _getBaseEmptyWidget() => getEmptyWidget();

  void initBaseCommon(State state, BuildContext context) {
    _stateBaseFunction = state;
    _contextBaseFunction = context;
  }

  ///暴露的错误页面方法，可以自己重写定制
  Widget getErrorWidget() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 200),
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: InkWell(
          onTap: onClickErrorWidget,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (!_errImgPath.empty)
                Image(
                  image: AssetImage(_errImgPath),
                  width: 150,
                  height: 150,
                ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text(
                  _errorContentMessage,
                  style: TextStyle(
                    fontWeight: _fontWidget,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///点击错误页面后执行逻辑
  void onClickErrorWidget() {
  }

  Widget getLoadingWidget() {
    return Container(
      color: Colors.black12,
      width: double.infinity,
      height: double.infinity,
      child: Container(
        color: Colors.black12,
        child: const Center(
          child: CupertinoActivityIndicator(radius: 15),
        ),
      ),
    );
  }

  Widget getEmptyWidget() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 200),
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (!_emptyImgPath.empty)
                Image(
                  color: Colors.black12,
                  image: AssetImage(_emptyImgPath),
                  width: 150,
                  height: 150,
                ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text(_emptyWidgetContent,
                    style: TextStyle(
                      fontWeight: _fontWidget,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  ///关闭最后一个 flutter 页面 ， 如果是原生跳过来的则回到原生，否则关闭app
  void finishDartPageOrApp() {
    SystemNavigator.pop();
  }

  ///设置错误提示信息
  void setErrorContent(String content) {
    if (_stateBaseFunction != null && _stateBaseFunction!.mounted) {
      // ignore: invalid_use_of_protected_member
      _stateBaseFunction!.setState(() {
        _errorContentMessage = content;
      });
    }
  }

  ///设置错误页面显示或者隐藏
  void setErrorWidgetVisible(bool isVisible) {
    if (_stateBaseFunction != null && _stateBaseFunction!.mounted) {
      // ignore: invalid_use_of_protected_member
      _stateBaseFunction!.setState(() {
        if (isVisible) {
          //如果可见 说明 空页面要关闭
          _isEmptyWidgetVisible = false;
        }
        // 不管如何loading页面要关闭，
        isLoadingWidgetShow = false;
        _isErrorWidgetShow = isVisible;
      });
    }
  }

  ///设置空页面显示或者隐藏
  void setEmptyWidgetVisible(bool isVisible) {
    if (_stateBaseFunction != null && _stateBaseFunction!.mounted) {
      // ignore: invalid_use_of_protected_member
      _stateBaseFunction!.setState(() {
        if (isVisible) {
          //如果可见 说明 错误页面关闭
          _isErrorWidgetShow = false;
        }

        // 不管如何loading页面关闭，
        isLoadingWidgetShow = false;
        _isEmptyWidgetVisible = isVisible;
      });
    }
  }

  void setLoadingWidgetVisible(bool isVisible) {
    if (_stateBaseFunction != null && _stateBaseFunction!.mounted) {
      // ignore: invalid_use_of_protected_member
      _stateBaseFunction!.setState(() {
        isLoadingWidgetShow = isVisible;
      });
    }
  }

  ///设置空页面内容
  void setEmptyWidgetContent(String content) {
    if (_stateBaseFunction != null && _stateBaseFunction!.mounted) {
      // ignore: invalid_use_of_protected_member
      _stateBaseFunction!.setState(() {
        _emptyWidgetContent = content;
      });
    }
  }

  ///设置错误页面图片
  void setErrorImage(String imagePath) {
    if (_stateBaseFunction != null && _stateBaseFunction!.mounted) {
      // ignore: invalid_use_of_protected_member
      _stateBaseFunction!.setState(() {
        _errImgPath = imagePath;
      });
    }
  }

  ///设置空页面图片
  void setEmptyImage(String imagePath) {
    if (_stateBaseFunction != null && _stateBaseFunction!.mounted) {
      // ignore: invalid_use_of_protected_member
      _stateBaseFunction!.setState(() {
        _emptyImgPath = imagePath;
      });
    }
  }

  void hideKeyboard(){
    FocusScope.of(_contextBaseFunction!).requestFocus(FocusNode());
  }

  String getWidgetName() => getWidgetNameByClass(_contextBaseFunction!);

  String getWidgetNameByClass(BuildContext? context) {
    if (context == null) {
      return "".toUpperCase();
    }
    String className = context.toString();

    if (isDebug) {
      try {
        className = className.substring(0, className.indexOf("("));
      } catch (err) {
        className = "";
      }
      return className;
    }

    return className;
  }

  void showLoading() {
    showDialog(
      context: _contextBaseFunction!,
      builder: (BuildContext context) {
        return Material(
          color: Colors.black.withOpacity(0.05),
          child: PopScope(
            child: Center(
              child: CupertinoActivityIndicator(radius: 10.w),
            ),
            onPopInvoked: (bool didPop) => Future.value(false),
          ),
        );
      },
    );
  }

  void stopLoading() {
    Navigator.of(_contextBaseFunction!).pop();
  }
}
