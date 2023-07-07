import 'package:easy_shaadi/ViewModel/providerclass.dart';
import 'package:easy_shaadi/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CartListTile extends StatelessWidget {
  CartListTile({this.lname = "", this.limage = "", this.lprice = 0, this.lquantity = 0,this.ldeliveryCharges=0,this.lsize='Custom'});

  String limage;
  String lname;
  String lsize;
  int lprice;
  int lquantity;
  int ldeliveryCharges;

  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(lname,
                            style: TextStyle(
                              fontSize: size.width *0.038,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Text(lsize, style: TextStyle(
                            fontSize: size.width *0.038,
                            fontWeight: FontWeight.bold,
                          ),),
                          const SizedBox(
                            height: 2,
                          ),
                          // Text(totalPrice!().toString() + ' Rs',
                          Text(lprice.toString() + ' Rs',
                            style: TextStyle(
                              fontSize: size.width *0.038,
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
                    Container(
                    height: 100,
                    child: Center(
                        child: Text('Quantity: ' + lquantity.toString(),
                          style: const TextStyle(
                              color: Colors.black,
                          ),
                        )
                    ),
                      ),

                    const SizedBox(
                      width: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: InkWell(
                          onTap: () {
                            bool check = false;
                            var ele;
                            myProvider.cartList.forEach((element) {
                              if (element.ProductName == lname) {
                                check = true;
                                ele = element;
                              }
                            });
                            if (check) {
                              myProvider.cartList.remove(ele);
                              myProvider.notifyListeners();
                              Fluttertoast.showToast(
                                msg: '$lname remove from cart',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 2,
                                backgroundColor: Colors.grey,
                                fontSize: 15,
                              );
                            }
                          },
                          child: Icon(Icons.delete)
                      ),
                    )
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }
}
