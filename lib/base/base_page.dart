part of base_module;

enum StartType { normal, removeUntil }

enum FinishType { normal, cancel }

abstract class BasePage extends StatefulWidget {
  late final String pagePath;
  late final dynamic stack;

  BasePage({Key? key}) : super(key: key) {
    String className = runtimeType.toString();
    String path = StackTrace.current.toString().split(className)[1];
    path = path.split(')')[0];
    path = path.split('(')[1];
    pagePath = '$className: ($path)';
  }
}

abstract class BasePageState<T extends BasePage> extends State<T>
    with
        WidgetsBindingObserver,
        BaseFunction,
        LifeCircle,
        BaseScaffold,
        AutomaticKeepAliveClientMixin {

  @override
  void initState() {
    initBaseCommon(this, context);
    NavigatorManger().addWidget(this);
    WidgetsBinding.instance.addObserver(this);

    if (_isAutoHandleHttpResult()) {
      HttpUtil().httpController().addListener(_onController);
    }
    LogUtil.log(tag: '当前页面 =====>', text: widget.pagePath);
    setComponentName(getWidgetName());
    onCreate();
    if (mounted) {
      WidgetsBinding.instance.endOfFrame.then((_) {
        if(mounted){
          firstRenderFinish();
        }
      });
    }
    super.initState();
  }

  @override
  void onCreate() {}

  void _onController() {
    if (_isAutoHandleHttpResult()) {
      if (isAutoHandleHttpEmpty()) {
        setEmptyWidgetVisible(HttpUtil()
            .httpController()
            .isEmpty);
      }
      if (isAutoHandleHttpError()) {
        setErrorWidgetVisible(HttpUtil()
            .httpController()
            .isError);
      }
      if (isAutoHandleHttpLoading()) {
        setLoadingWidgetVisible(HttpUtil()
            .httpController()
            .isLoading);
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (isKeepAlive()) {
      super.build(context);
    }
    buildBeforeReturn(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: statusBarStyle,
      child: _buildOnBackPressedWrapper(context),
    );
  }

  @override
  void dispose() {
    onDestroy();
    WidgetsBinding.instance.removeObserver(this);

    // 取消网络请求
    if (isCancelRequestWhenDispose()) {
      HttpUtil().cancelRequest(context.toString());
    }
    NavigatorManger().removeWidget(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // app前后台切换
    if (state == AppLifecycleState.resumed) {
      if (NavigatorManger().isTopPage(this)) {
        onForeground();
      }
    } else if (state == AppLifecycleState.paused) {
      if (NavigatorManger().isTopPage(this)) {
        onBackground();
      }
    }
    super.didChangeAppLifecycleState(state);
  }

  /// 点击返回按按钮时执行逻辑
  Widget _buildOnBackPressedWrapper(BuildContext context) {
    if (Platform.isIOS && canIosSwipeGoBack) {
      return _buildAutoHideKeyboardWrapper(context);
    } else {
      return PopScope(
        child: _buildAutoHideKeyboardWrapper(context),
        onPopInvoked: onBackPressed,
      );
    }
  }

  /// 点击页面收起键盘
  Widget _buildAutoHideKeyboardWrapper(BuildContext context) {
    return canClickPageHideKeyboard()
        ? GestureDetector(
      onTap: hideKeyboard,
      child: _buildProviderWrapper(context),
    )
        : _buildProviderWrapper(context);
  }

  /// 封装状态管理组件
  Widget _buildProviderWrapper(BuildContext context) {
    return !getProvider(context).empty
        ? MultiProvider(
      providers: getProvider(context),
      child: _buildCustomerPageLayout(_buildContentWrapper(context)) ??
          _buildPageLayout(_buildContentWrapper(context)),
    )
        : _buildCustomerPageLayout(_buildContentWrapper(context)) ??
        _buildPageLayout(_buildContentWrapper(context));
  }

  /// 封装错误,空白,加载中组件
  Widget _buildContentWrapper(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 0,
          top: 0,
          right: 0,
          bottom: 0,
          child: setCustomerPageContent(context: context) ??
              setPageContent(context),
        ),
        if (_isErrorWidgetShow)
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            bottom: 0,
            child: _getBaseErrorWidget(),
          ),
        if (_isEmptyWidgetVisible)
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            bottom: 0,
            child: _getBaseEmptyWidget(),
          ),
        if (isLoadingWidgetShow)
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            bottom: 0,
            child: _getBassLoadingWidget(),
          ),
      ],
    );
  }

  Widget? _buildCustomerPageLayout(Widget content) {
    if (setCustomerPageContent() == null) return null;
    return Container(
      child: content,
    );
  }

  Widget _buildPageLayout(Widget content) {
    return Scaffold(
      key: baseScaffoldKey,
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      floatingActionButtonAnimator: floatingActionButtonAnimator,
      persistentFooterButtons: persistentFooterButtons,
      drawer: drawer,
      endDrawer: endDrawer,
      bottomNavigationBar: bottomNavigationBar,
      bottomSheet: bottomSheet,
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      primary: primary ?? true,
      drawerDragStartBehavior:
      drawerDragStartBehavior ?? DragStartBehavior.start,
      extendBody: extendBody ?? false,
      extendBodyBehindAppBar: extendBodyBehindAppBar ?? false,
      drawerScrimColor: drawerScrimColor,
      drawerEdgeDragWidth: drawerEdgeDragWidth,
      drawerEnableOpenDragGesture: drawerEnableOpenDragGesture ?? true,
      endDrawerEnableOpenDragGesture: endDrawerEnableOpenDragGesture ?? true,
      body: content,
    );
  }

  @override
  bool get wantKeepAlive => isKeepAlive();

  /// 是否自动处理网络请求对应页面展示
  bool _isAutoHandleHttpResult() =>
      isAutoHandleHttpLoading() ||
          isAutoHandleHttpError() ||
          isAutoHandleHttpEmpty();

  /*------------------------------------ 子类实现方法 ------------------------------------*/

  ///未设置AppBar时状态栏字体颜色
  SystemUiOverlayStyle get statusBarStyle => SystemUiOverlayStyle.dark;

  /// 是否在销毁时取消页面请求
  bool isCancelRequestWhenDispose() => false;

  /// 是否自动处理网络请求加载
  bool isAutoHandleHttpLoading() => false;

  /// 是否自动处理网络请求响应空数据
  bool isAutoHandleHttpEmpty() => false;

  /// 是否自动处理网络请求响应错误
  bool isAutoHandleHttpError() => false;

  /// 返回true直接退出,当子类需要添加点击返回逻辑时重写该方法,默认true
  Future<bool> onBackPressed(bool didPop) async => true;

  /// 重写改变返回值,true-点击页面时收起键盘,false无此功能,默认true
  bool canClickPageHideKeyboard() => true;

  /// 当页面存在PageView时,如果需要保证每一个tab不被销毁重写返回true
  bool isKeepAlive() => false;

  /// 重写添加状态管理的provider
  List<SingleChildWidget> getProvider(BuildContext context) {
    return [];
  }

  /// ios禁用左滑返回
  bool get canIosSwipeGoBack => true;

  /// 不使用Scaffold时重写,页面中可调用或重写
  /// [setErrorContent] - 重写自定义错误控件
  /// [setErrorWidgetVisible] - 控制错误控件显示
  /// [setEmptyWidgetVisible] -  控制空白控件显示
  /// [setLoadingWidgetVisible] - 控制加载中控件显示
  /// [setEmptyWidgetContent] - 重写自定义空白控件
  /// [setErrorImage] - 设置错误图片
  /// [setEmptyImage] - 设置空白图片
  /// [finishDartPageOrApp] - 退出flutterEngine
  /// 等方法.....
  ///
  /// [setCustomerPageContent]返回null时页面显示[setPageContent]返回内容,
  /// [setCustomerPageContent]返回不为null时[setPageContent]不生效
  Widget? setCustomerPageContent({BuildContext? context}) => null;

  /// 使用Scaffold时重写,返回为Scaffold的body,
  /// Scaffold其他参数重写[BaseScaffold]对应字段getter方法.
  ///
  /// 页面中可调用或重写
  /// [setErrorContent] - 重写自定义错误控件
  /// [setErrorWidgetVisible] - 控制错误控件显示
  /// [setEmptyWidgetVisible] -  控制空白控件显示
  /// [setLoadingWidgetVisible] - 控制加载中控件显示
  /// [setEmptyWidgetContent] - 重写自定义空白控件
  /// [setErrorImage] - 设置错误图片
  /// [setEmptyImage] - 设置空白图片
  /// [finishDartPageOrApp] - 退出flutterEngine
  /// 等方法.....
  ///
  /// [setCustomerPageContent]返回null时页面显示[setPageContent]返回内容,
  /// [setCustomerPageContent]返回不为null时[setPageContent]不生效
  Widget setPageContent(BuildContext context) =>
      const SizedBox(
        width: 20,
        height: 20,
        child: Text(''),
      );

  /// 重写添加build方法return前需要执行的逻辑
  void buildBeforeReturn(BuildContext context) {}

  void firstRenderFinish(){

  }
}
