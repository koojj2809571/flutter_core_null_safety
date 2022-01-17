part of base_module;

abstract class BaseComponent extends StatefulWidget {
  late final String componentPath;

  BaseComponent({Key? key}) : super(key: key){
    if(isDebug) {
      String className = toString();
      String path = StackTrace.current.toString().split(className)[1];
      path = path.split(')')[0];
      path = path.split('(')[1];
      componentPath = '$className: ($path)';
    }
  }

}

abstract class BaseComponentState<T extends BaseComponent> extends State<T> {

  @override
  void initState() {
    super.initState();
    LogUtil.log(tag: '组件 =====>', text: widget.componentPath);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
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
}
