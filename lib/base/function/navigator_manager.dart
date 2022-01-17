part of base_module;

class NavigatorManger {
  final List<BasePageState> _activityStack = [];

  NavigatorManger._internal();

  static final NavigatorManger _instance = NavigatorManger._internal();

  factory NavigatorManger() => _instance;
  void addWidget(BasePageState baseState) {
    _activityStack.add(baseState);
  }

  void removeWidget(BasePageState baseState) {
    HttpUtil(). removeCancelToken(baseState.context);
    _activityStack.remove(baseState);
  }

  bool isTopPage(BasePageState baseState) {
    try {
      return baseState.getWidgetName() ==
          _activityStack[_activityStack.length - 1].getWidgetName();
    } catch (exception) {
      return false;
    }
  }

  bool isSecondTop(BasePageState baseState) {
    try {
      return baseState.getWidgetName() ==
          _activityStack[_activityStack.length - 2].getWidgetName();
    } catch (exception) {
      return false;
    }
  }
}