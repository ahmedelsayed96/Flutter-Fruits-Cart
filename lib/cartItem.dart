import 'package:flutter/material.dart';
import 'package:fruits/fruit.dart';
import 'package:fruits/main.dart';

class CartItem extends StatefulWidget {
  Fruit fruit;
  int index;

  CartItem(this.fruit, this.index);

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> with TickerProviderStateMixin {
  AnimationController moveController;
  Animation moveAnimation;

  AnimationController scaleController;
  Animation scaleAnimation;

  AnimationController secondMoveController;
  Animation secondMoveAnimation;

  Position fromPosition;
  GlobalKey currentKey = GlobalKey();

  @override
  void initState() {
    moveController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 700));
    secondMoveController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 700));
    scaleController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300),upperBound: .3);

    moveAnimation =
        CurvedAnimation(parent: moveController, curve: Curves.easeInOut);
    scaleAnimation =
        CurvedAnimation(parent: scaleController, curve: Curves.easeInOut);
    secondMoveAnimation =
        CurvedAnimation(parent: secondMoveController, curve: Curves.easeInOut);
    moveController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    fromPosition = widget.fruit.position;
    return Container(
        key: currentKey,
        height: 120,
        width: 90,
        child: widget.fruit.qty == 1 ? buildMoving() : buildStackMoving());
  }

  Widget buildMoving() {
    return AnimatedBuilder(
        animation: moveAnimation,
        builder: (context, snapshot) {
          Position currentPosition;
          double x = 0, y = 0;
          if (currentKey.currentContext.findRenderObject() != null) {
            currentPosition = getPositionbyKey(currentKey);
            x = fromPosition.x -
                currentPosition.x +
                fromPosition.size.width -
                90;
            y = fromPosition.y - currentPosition.y;
          }
          if (x == 0) return Container();
          return Transform.translate(
              offset: Offset(x * (1 - moveAnimation.value),
                  y * (1 - moveController.value)),
              child: buildCard());
        });
  }

  Widget buildCard({double opacity = 1}) {
    return Column(
      children: <Widget>[
        Opacity(opacity: opacity, child: buildContainerImage()),
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.black),
              borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: Text('${widget.fruit.qty}'),
          ),
        )
      ],
    );
  }

  Widget buildContainerImage({double size = 80}) {
    return Container(
      width: size,
      height: size,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: widget.fruit.color),
      child: Image.asset(
        widget.fruit.image,
        width: 40,
        height: 40,
      ),
    );
  }

  Widget buildStackMoving() {

    if(widget.fruit.animate){
      widget.fruit.animate=false;
      scaleController.reset();
      scaleController.forward();
      secondMoveController.reset();
      secondMoveController.forward();
    }
    return Stack(
      children: <Widget>[
        AnimatedBuilder(
            animation: scaleController,
            builder: (context, snapshot) {
              return Transform.scale(scale: 1-scaleController.value, child: buildCard(opacity: .4));
            }),
        AnimatedBuilder(
            animation: secondMoveAnimation,
            builder: (context, snapshot) {
              Position currentPosition;
              double x = 0, y = 0;
              if (currentKey.currentContext.findRenderObject() != null) {
                currentPosition = getPositionbyKey(currentKey);
                x = fromPosition.x -
                    currentPosition.x +
                    fromPosition.size.width -
                    90;
                y = fromPosition.y - currentPosition.y;
              }
              if (x == 0) return Container();
              return Transform.translate(
                offset: Offset(x * (1 - secondMoveAnimation.value),
                    y * (1 - secondMoveController.value)),
                child: Center(
                    heightFactor: .9, child: buildContainerImage(size: 70)),
              );
            })
      ],
    );
  }
}
