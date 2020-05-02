


import 'dart:ui';

import 'package:fruits/main.dart';

class Fruit{
  String name ;
  String image ;
  double price ;
  int qty =0;
  Color color;
  Position position;
  bool animate =false;

  Fruit(this.name, this.image, this.price, this.qty,this.color);

  set Qty(int qty)=>this.qty=qty;
  set reAnimate(bool animate)=>this.animate =animate;

  set currentPosition(Position position)=>this.position=position;

  @override
  bool operator ==(other) {
    // TODO: implement ==
    return this.name==other.name;
  }

}