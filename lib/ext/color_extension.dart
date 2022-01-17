part of extenssion_module;

extension ColorUtil on Color {
  String get hex {
    String color;
    String a = alpha.toRadixString(16);
    String r = red.toRadixString(16);
    String g = green.toRadixString(16);
    String b = blue.toRadixString(16);
    color = '#$a$r$g$b';
    return color;
  }
}