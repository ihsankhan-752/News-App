void main() {
  AppUtils appUtils = AppUtils();
  appUtils.myColor();
  String myColor = appUtils.whiteColor;
  print(myColor);
}

mixin Colors {
  String redColor = 'Red';
  String whiteColor = 'white';
}

class AppUtils with Colors {
  void myColor() {
    print(redColor + whiteColor);
  }
}
