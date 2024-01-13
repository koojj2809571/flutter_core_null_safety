import 'package:flutter/material.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import 'base_page_request.dart';
import 'base_page_response.dart';

typedef SendRequest = Future<BasePageResponse> Function();
typedef NotifyAfterRefresh<T> = void Function(BasePageResponse<T> response);

class RefreshList extends StatefulWidget {
  final BasePageRequest param;
  final SendRequest sendRequest;
  final Function itemWidget;
  final Function itemClick;
  final RefreshController? controller;
  final NotifyAfterRefresh? notify;

  const RefreshList({Key? key,
    required this.param,
    required this.sendRequest,
    required this.itemWidget,
    required this.itemClick,
    this.controller,
    this.notify
  }) : super(key: key);

  @override
  _RefreshListState createState() => _RefreshListState();
}

class _RefreshListState<R> extends State<RefreshList> {
  late RefreshController _refreshCtr;
  late BasePageRequest param;
  late SendRequest sendRequest;
  late Function itemWidget;

  BasePageResponse? data;

  @override
  void initState() {
    super.initState();
    _refreshCtr = widget.controller ?? RefreshController();
    param = widget.param;
    sendRequest = widget.sendRequest;
    itemWidget = widget.itemWidget;
  }

  @override
  Widget build(BuildContext context) {
    return _refrsh();
  }

  void _onRefresh() {
    param.setPage(0);
    sendRequest().then((value) {
      if(widget.notify != null) widget.notify!(value);
      setState(() {
        data = value;
      });
      _refreshCtr.refreshCompleted();
    }).catchError((onError) {
      onError.log();
      _refreshCtr.refreshCompleted();
      setState(() {
        data = null;
      });
    });
  }

  void _onLoading(){
    param.setPage(param.valuePage() + 1);
    sendRequest().then((value) {
      setState(() {
        data!.valueList().addAll(value.valueList());
      });
      _refreshCtr.refreshCompleted();
    }).catchError((onError) {
      onError.log();
      _refreshCtr.refreshCompleted();
      setState(() {
        data = null;
      });
    });
  }

  Widget _refrsh(){
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: const WaterDropHeader(),
      footer: const ClassicFooter(
        idleText: '上拉加载',
        loadingText: '加载中',
        noDataText: '没有更多数据',
        canLoadingText: '上拉加载',
      ),
      controller: _refreshCtr,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: ListView.builder(
        itemBuilder: (c, i) => itemWidget(data!.valueList()[i]),
        itemExtent: 100.0,
        itemCount: data!.valueList().length,
      ),
    );
  }

}
