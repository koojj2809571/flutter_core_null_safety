library tree_selector;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part 'tree_model.dart';

class TreeSelectDialog<T extends BaseTreeData> extends StatefulWidget {
  final T treeData;
  final Function onSelectedCall;

  const TreeSelectDialog({
    super.key,
    required this.treeData,
    required this.onSelectedCall,
  });

  @override
  _TreeSelectDialogState createState() => _TreeSelectDialogState();
}

class _TreeSelectDialogState extends State<TreeSelectDialog>
    with TickerProviderStateMixin {
  final Map<int, List<dynamic>> _datas = {};
  final Map<int, String> _selectNameDatas = {};
  final List<String> _tabs = ['请选择'];
  late TabController _tabController;
  int currentTabPos = 0;

  @override
  void initState() {
    super.initState();
    //初始化第一层级所需要显示的内容
    List<dynamic> list = widget.treeData.getTreeData();
    //datas第一层级初始化赋值
    _datas[currentTabPos] = list;
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        duration: const Duration(milliseconds: 100),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            color: Colors.white,
          ),
          height: 350,
          child: Flex(
            direction: Axis.vertical,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                  left: 10.w,
                  right: 10.w,
                ),
                height: 40.h,
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: TabBar(
                    controller: _tabController,
                    unselectedLabelColor: Colors.grey,
                    labelColor: Colors.blue,
                    indicatorColor: Colors.blue,
                    labelStyle: TextStyle(fontSize: 16.sp),
                    isScrollable: true,
                    indicatorWeight: 3,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorPadding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    onTap: (index) {
                      if (!mounted) {
                        return;
                      }
                      setState(() {
                        //获取当前tab有多少
                        int size = _tabs.length;
                        //记录当前位置
                        currentTabPos = index;
                        //循环处理，将当前位置之后的数据去除
                        for (int i = size; i > currentTabPos + 1; i--) {
                          _tabs.removeAt(i - 1);
                          _selectNameDatas.remove(i - 1);
                        }
                        //这一步是重新创建tab
                        _tabController = TabController(
                          length: _tabs.length,
                          vsync: this,
                        );
                        //将当前tab移动到选中的位置上
                        _tabController.animateTo(currentTabPos);
                      });
                    },
                    tabs: _tabs.map((e) => Tab(text: e)).toList(),
                  ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: TabBarView(
                    children: _buildPages(),
                    controller: _tabController,
                    physics: const NeverScrollableScrollPhysics(),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPages() {
    List<Widget> pages = [];
    for (int i = 0; i < _tabs.length; i++) {
      Widget page = ListView.builder(
        padding: EdgeInsets.only(top: 15.w),
        itemCount: _datas[i]!.length,
        itemBuilder: (BuildContext context, int index) {
          return _getListItem(index, _datas[i]!);
        },
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
      );
      pages.add(page);
    }
    return pages;
  }

  Widget _getListItem(int index, List<dynamic> datas) {
    dynamic currentData = datas[index];
    return GestureDetector(
      child: Container(
        alignment: Alignment.centerLeft,
        color: Colors.white,
        height: 50,
        padding: const EdgeInsets.only(left: 15),
        child: Text(
          currentData.getName(),
          style: TextStyle(
              fontSize: 15,
              color: _selectNameDatas[currentTabPos] == currentData.getName()
                  ? Colors.blue
                  : Colors.grey),
        ),
      ),
      onTap: () {
        if (!mounted) {
          return;
        }
        setState(() {
          if (currentData.getTreeData() != null &&
              currentData.getTreeData().length > 0) {
            //这是选中的tab还有下级数据时
            _tabs[currentTabPos] = currentData.getName();
            currentTabPos++;
            _datas[currentTabPos] = currentData.getTreeData();
            _selectNameDatas[currentTabPos - 1] = currentData.getName();
            _tabs.add("请选择");
            _tabController = TabController(
              length: _tabs.length,
              vsync: this,
            );
            _tabController.animateTo(currentTabPos);
          } else {
            //这是选中的tab没有下级数据时
            _tabs[currentTabPos] = currentData.getName();
            _selectNameDatas[currentTabPos] = currentData.getName();
            Navigator.pop(context);
            //这个是处理选中的名称拼接，根据自己的业务去甄别
            String names = "";
            for (int i = 0; i < _selectNameDatas.length; i++) {
              if (i == _selectNameDatas.length - 1) {
                names += _selectNameDatas[i]!;
              } else {
                names += "${_selectNameDatas[i]}-";
              }
            }
            //将选中的数据实时回调到需要的地方
            widget.onSelectedCall(names, currentData);
          }
        });
      },
    );
  }
}
