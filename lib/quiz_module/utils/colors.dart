import 'dart:math';
import 'dart:ui';

class ManyColors{
  //
  static const Color color0 = Color(0xffffb55f);
  static const Color color1 = Color(0xff5cc3c2);
  static const Color color2 = Color(0xffd77071);
  static const Color color3 = Color(0xffffc3c5);
  static const Color color4 = Color(0xff415556);
  static const Color color5 = Color(0xff999594);
  //
  static const Color color6 = Color(0xff0f1d68);
  static const Color color7 = Color(0xff423151);
  static const Color color8 = Color(0xff9e7fa9);
  static const Color color9 = Color(0xfffff38f);
  static const Color color10 = Color(0xfffdd448);
  //
  static const Color color11 = Color(0xff019002);
  static const Color color12 = Color(0xff84e502);
  static const Color color13 = Color(0xff7bcfbf);
  static const Color color14 = Color(0xff14899b);
  static const Color color15 = Color(0xff002923);
  //
  static const Color color16 = Color(0xfff5222d);
  static const Color color17 = Color(0xfffa8c16);
  static const Color color18 = Color(0xff5cdbd3);
  static const Color color19 = Color(0xff69c0ff);
  static const Color color20 = Color(0xff597ef7);

  static const gradient1 = [Color.fromARGB(255, 33, 206, 186), Color.fromARGB(255, 172, 229, 184)];
  static const gradient2 = [Color(0xFFe3598c), Color(0xFFfaa85f)];
  static const gradient3 = [Color(0xFF2b838d), Color(0xFFee8774)];
  static const gradient4 = [Color(0xFF143838), Color(0xFFebb450)];
  static const gradient5 = [Color(0xFF70c7b6), Color(0xFFd01b86)];
  static const gradient6 = [Color(0xFF53b9ea), Color(0xFF9f68ac)];
  static const gradient7 = [Color(0xFFf4e8fa), Color(0xFF00c0f9)];
  static const gradient8 = [Color(0xFF6ce8fd), Color(0xFF0d015b)];
  static const gradient9 = [Color(0xFFb3eb50), Color(0xFF429421)];
  static const gradient10 = [Color(0xFFff57b9), Color(0xFFa704fd)];
  static const gradient16 = [Color(0xff00bbdc), Color(0xff03cbc8)];
  static const gradient17 = [Color(0xFF000000), Color(0xFF0d015b)];

  static const gradient11 = [Color(0xFFff57b9), Color(0xFF1b138d), Color(0xFF1b138d)];
  static const gradient12 = [Color(0xFF70c7b6), Color(0xffFFFFFF), Color(0xffFFFFFF), Color(0xffFFFFFF)];
  static const gradient13 = [Color(0xfff5222d), Color(0xffFFFFFF), Color(0xffFFFFFF), Color(0xffFFFFFF)];
  static const gradient14 = [Color(0xff019002), Color(0xffFFFFFF), Color(0xffFFFFFF), Color(0xffFFFFFF)];
  static const gradient15 = [Color(0xff002923), Color(0xffFFFFFF), Color(0xffFFFFFF), Color(0xffFFFFFF)];

}

Color getRandomColor() {
  Random random = Random();
  return Color.fromARGB(random.nextInt(300), random.nextInt(300),
      random.nextInt(300), random.nextInt(300));
}
