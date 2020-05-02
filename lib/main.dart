import 'package:flutter/material.dart';
import 'package:fruits/cartItem.dart';

import 'fruit.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  AnimationController slideController;
  List<Fruit> cartFruits = [];

  @override
  void initState() {
    slideController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    super.initState();
  }

  @override
  void dispose() {
    slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          AnimatedBuilder(
              animation: slideController,
              builder: (context, snapshot) {
                return Positioned(
                    width: size.width - (105 * (slideController.value)),
                    height: size.height,
                    child: buildSafeArea());
              }),
          
             AnimatedBuilder(
               animation: slideController,
               builder: (context, snapshot) {
                 return Positioned(
                  right: 102*(slideController.value),
                  child: SafeArea(
                    child: Container(
                      height: size.height,
                      width: 2,
                      color: Colors.grey[400],
                    ),
                  ),
            );
               }
             ),
            AnimatedBuilder(
              animation: slideController,
              builder: (context, snapshot) {
                return Positioned(
                  right: 0,
                  height: size.height,
                  width: 100*slideController.value,
                  child: buildSecondList(),
                );
              }
            )
          
        ],
      ),
    );
  }

  Widget buildSafeArea() {
    return SafeArea(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          buildTopBar(),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView(
              children: getFruitsList().map((f) => buildFruit(f)).toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget buildTopBar() {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 10,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          decoration: BoxDecoration(
              color: Colors.grey[300], borderRadius: BorderRadius.circular(25)),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 20,
              ),
              Icon(Icons.search),
              SizedBox(
                width: 20,
              ),
              Text('Search'),
              SizedBox(
                width: 60,
              )
            ],
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Icon(Icons.local_bar),
        Spacer(),
      ],
    );
  }

  List<Fruit> getFruitsList() {
    List<Fruit> fruits = [];
    fruits.add(Fruit('Apple', 'images/apple.png', 52.0, 0, Colors.red));
    fruits.add(Fruit('Banana', 'images/banana.png', 30.0, 0, Colors.amber));
    fruits.add(
        Fruit('Strawberry', 'images/strawberry.png', 45.0, 0, Colors.red[300]));
    fruits
        .add(Fruit('Orange', 'images/orange.png', 55.0, 0, Colors.orange[300]));
    fruits.add(Fruit('Lemon', 'images/lemon.png', 60.0, 0, Colors.yellow[600]));

    return fruits;
  }

  Widget buildFruit(Fruit fruit) {
    GlobalKey key =GlobalKey();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            )),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    key: key,
                    color: fruit.color,
                    child: Image.asset(
                      fruit.image,
                      height: 100,
                    ),
                  ),
                  Container(
                    height: 50,
                    margin: EdgeInsets.only(left: 20, bottom: 10),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        fruit.name,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20),
              child: Text(
                '\$${fruit.price}',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
            InkWell(
              onTap: () {
                if (cartFruits.length == 0) slideController.forward();
                setState(() {
                  fruit.currentPosition = getPositionbyKey(key);
                  int index = cartFruits.indexOf(fruit);
                  if(index !=-1){
                    cartFruits[index].Qty=cartFruits[index].qty+1;
                    cartFruits[index].qty==2?cartFruits[index].reAnimate=true
                        :null;
                  }else{
                    fruit.Qty=1;
                    cartFruits.add(fruit);
                  }

                });

              },
              child: Card(
                elevation: 4,
                child: Container(
                  height: 60,
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Icon(Icons.add_circle_outline),
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  Widget buildSecondList() {
    return SafeArea(
      child: Column(
        children: <Widget>[
          SizedBox(height: 24,),
          Icon(Icons.shopping_cart),
          SizedBox(height: 20,),
          Expanded(
            child: ListView.builder(
              itemCount: cartFruits.length,
              itemBuilder: (context,index){
                return CartItem(cartFruits[index],index);
              },

            ),
          )


        ],
      ),
    );
  }
}

Position getPositionbyKey(GlobalKey key) {
  RenderBox box = key.currentContext.findRenderObject();
  Size size = box.size;
  Offset position = box.localToGlobal(Offset.zero); //this is global position
  double x = position.dx;
  double y = position.dy;
  return Position(x, y, size);
}

class Position {
  double x;

  double y;
  Size size;

  Position(this.x, this.y, this.size);
}