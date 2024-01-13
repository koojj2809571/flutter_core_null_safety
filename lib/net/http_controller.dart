part of net_module;

class HttpController extends ChangeNotifier{

  bool isLoading = false;
  bool isError = false;
  bool isEmpty = false;

  String errorMessage = '';

  void startLoading(){
    isLoading = true;
    isError = false;
    isEmpty = false;
    errorMessage = '';
    notifyListeners();
  }

  void stopLoading(){
    isLoading = false;
    notifyListeners();
  }

  void onSuccess(){
    isLoading = false;
    notifyListeners();
  }

  void onError(DioException e){
    isLoading = false;
    isError = true;
    errorMessage = e.message ?? 'UNKNOWN_ERROR';
    notifyListeners();
  }

  void onEmpty(){
    isLoading = false;
    isEmpty = true;
    notifyListeners();
  }
}