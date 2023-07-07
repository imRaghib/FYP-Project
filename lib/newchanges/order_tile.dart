import 'package:easy_shaadi/ViewModel/providerclass.dart';
import 'package:easy_shaadi/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OrderTile extends StatelessWidget {
  OrderTile({this.lname = "", this.limage = "", this.lprice = 0,});

  String limage;
  String lname;
  int lprice;

  @override
  Widget build(BuildContext context) {
    var myProvider = Provider.of<ProductProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 2,
        shadowColor: kPink.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),

        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                child: Container(
                  height: 85,
                  child: Image.network(
                    limage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
                child: Container(
                  height: 100,
                  child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(lname,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 2,
                          ),

                          // Text(totalPrice!().toString() + ' Rs',
                          Text(lprice.toString() + ' Rs',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),)
                        ],
                      )
                  ),
                )
            ),
            Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.arrow_forward_ios)
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }
}
