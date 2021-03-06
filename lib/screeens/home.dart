import 'package:flutter/material.dart';
import 'package:animation/widgets/cat.dart';
import 'dart:math';

class Home extends StatefulWidget {

  Home({Key key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();

}

class _HomeState extends State<Home> with TickerProviderStateMixin {

  Animation<double> catAnimation;
  AnimationController catController;
  Animation<double> boxAnimation;
  AnimationController boxController;

  @override
  void initState() {
    super.initState();

    boxController = AnimationController(
      duration: Duration(milliseconds: 300,),
      vsync: this,
    );
    boxAnimation = Tween(
      begin: pi * 0.6,
      end: pi * 0.65,
    ).animate(
      CurvedAnimation(
        parent: boxController,
        curve: Curves.easeInOut,
      ),
    );
    boxAnimation.addStatusListener((status) {
      if(status == AnimationStatus.completed) {
        setState(() {
          boxController.reverse();
        });
      }
      else if(status == AnimationStatus.dismissed) {
        setState(() {
          boxController.forward();
        });
      }
    });
    setState(() {
      boxController.forward();
    });

    catController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    catAnimation = Tween(begin: -35.0, end: -80.0).animate(
      CurvedAnimation(
        parent: catController,
        curve: Curves.easeIn,
      ),
    );
  }

  onTap() {
    if(catController.status == AnimationStatus.completed) {
      setState(() {
        boxController.forward();
        catController.reverse();
      });
    }
    else if(catController.status == AnimationStatus.dismissed) {
      setState(() {
        boxController.stop();
        catController.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animation!'),
      ),
      body: GestureDetector(
        child: Center(
          child: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              buildCatAnimation(),
              buildBox(),
              buildLeftFlap(),
              buildRightFlap(),
            ],
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget buildCatAnimation() {
    return AnimatedBuilder(
      animation: catAnimation,
      builder: (context, child) {
        return Positioned(
          child: child,
          top: catAnimation.value,
          right: 0.0,
          left: 0.0,
        );
      },
      child: Cat(),
    );
  }

  Widget buildBox() {
    return Container(
      child: Image(image: AssetImage('assets/images/boximage.png'),
      fit: BoxFit.fill,
      ),
      height: 200.0,
      width: 200.0,
    );
  }

  Widget buildLeftFlap() {
    return Positioned(
      left: 3.0,
      child: AnimatedBuilder(
        animation: boxAnimation,
        child: Container(
          child: Image(image: AssetImage('assets/images/boximage.png'),
            fit: BoxFit.fill,
          ),
          height: 10.0,
          width: 125.0,
        ),
        builder: (context, child) {
          return Transform.rotate(
            child: child,
            alignment: Alignment.topLeft,
            angle: boxAnimation.value,
          );
        },
      ),
    );
  }

  Widget buildRightFlap() {
    return Positioned(
      right: 3.0,
      child: AnimatedBuilder(
        animation: boxAnimation,
        child: Container(
          child: Image(image: AssetImage('assets/images/boximage.png'),
            fit: BoxFit.fill,
          ),
          height: 10.0,
          width: 125.0,
        ),
        builder: (context, child) {
          return Transform.rotate(
            child: child,
            alignment: Alignment.topRight,
            angle: -boxAnimation.value,
          );
        },
      ),
    );
  }

}