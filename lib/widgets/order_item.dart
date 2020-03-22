import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';

class OrderItem extends StatefulWidget {
  final OrderItems order;

  OrderItem(this.order);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return OrderState();
  }
}

class OrderState extends State<OrderItem> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  Animation<double> _fadedanimation;
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 300),
        reverseDuration: Duration(milliseconds: 300));
    _fadedanimation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(curve: Curves.easeIn, parent: _controller));
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(children: <Widget>[
      Card(
        child: ListTile(
          title: Text('\$${widget.order.amount}'),
          subtitle: Text(
              DateFormat('dd-MMM-yyyy  hh-mm').format(widget.order.dateTime)),
          trailing: IconButton(
              icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  if(_isExpanded){
                    _controller.reverse();
                  }else{
                    _controller.forward();
                  }
                  _isExpanded = !_isExpanded;
                });
              }),
        ),
      ),
      AnimatedContainer(
        constraints: BoxConstraints(minHeight: _isExpanded? 20: 0, maxHeight: _isExpanded? 100: 0),
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
          padding: EdgeInsets.only(left: 20, bottom: 10, right: 10),
          height: 100,
          child: FadeTransition(
            opacity: _fadedanimation,
            child: Card(
              child: Padding(
                  padding: EdgeInsets.all(5),
                  child: ListView.builder(
                    itemBuilder: (ctx, idx) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            widget.order.products[idx].title,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          Text(
                              '\$${widget.order.products[idx].price.toString()}'),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                              '${widget.order.products[idx].quantity.toString()} x'),
                        ],
                      );
                    },
                    itemCount: widget.order.products.length,
                  )),
            ),
          ))
    ]);
  }
}
