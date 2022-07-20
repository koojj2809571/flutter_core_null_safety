part of base_module;

abstract class BaseFragment extends StatefulWidget {
  late final String componentPath;

  BaseFragment({Key? key}) : super(key: key) {
      String className = toString();
      String path = StackTrace.current.toString().split(className)[1];
      path = path.split(')')[0];
      path = path.split('(')[1];
      componentPath = '$className: ($path)';
  }
}

abstract class BaseFragmentState<T extends BaseFragment> extends State<T>
    with WidgetsBindingObserver, LifeCircle, BaseScaffold {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    LogUtil.log(tag: '碎片 =====>', text: widget.componentPath);
    setComponentName(getWidgetName());
    onCreate();
    if (mounted) {}

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    buildBeforeReturn(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: statusBarStyle,
      child: _buildAutoHideKeyboardWrapper(context),
    );
  }

  @override
  void onCreate() {}

  @override
  void dispose() {
    onDestroy();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  String getWidgetName() => getWidgetNameByClass(context);

  String getWidgetNameByClass(BuildContext context) {
    String className = this.context.toString();
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

  /// 点击页面收起键盘
  Widget _buildAutoHideKeyboardWrapper(BuildContext context) {
    return canClickPageHideKeyboard()
        ? GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: _buildProviderWrapper(context),
          )
        : _buildProviderWrapper(context);
  }

  /// 封装状态管理组件
  Widget _buildProviderWrapper(BuildContext context) {
    return !getProvider().empty
        ? MultiProvider(
            providers: getProvider() ?? [],
            child: setCustomerPageContent(context: context) ??
                _buildPageLayout(setPageContent(context)),
          )
        : setCustomerPageContent(context: context) ??
            _buildPageLayout(setPageContent(context));
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

  ///未设置AppBar时状态栏字体颜色
  SystemUiOverlayStyle get statusBarStyle => SystemUiOverlayStyle.dark;

  /// 重写添加状态管理的provider
  List<SingleChildWidget>? getProvider() {
    return null;
  }

  /// 重写添加build方法return前需要执行的逻辑
  void buildBeforeReturn(BuildContext context) {}

  /// 重写改变返回值,true-点击页面时收起键盘,false无此功能,默认false
  bool canClickPageHideKeyboard() => false;

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
  Widget setPageContent(BuildContext context) => const SizedBox(
        width: 20,
        height: 20,
        child: Text(''),
      );
}
