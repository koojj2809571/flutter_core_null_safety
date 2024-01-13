part of base_module;

mixin class LifeCircle{

  String? name;

  void setComponentName(String name) => this.name = name;

  ///初始化一些变量 相当于android onCreate,初始化数据操作
  void onCreate(){}

  ///app切回到后台
  void onBackground() {
    LogUtil.log(text: "$name-回到后台");
  }

  ///app切回到前台
  void onForeground() {
    LogUtil.log(text: "$name-回到前台");
  }

  ///页面注销方法
  void onDestroy() {
  }
}