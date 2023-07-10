import 'package:easy_shaadi/View/User%20Pages/OrderDeliveryInfo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ViewModel/providerclass.dart';
import '../constants.dart';
import 'Cart_tile.dart';
import 'cartButton.dart';

class ReviewCart extends StatelessWidget {
  const ReviewCart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int totalDelivery=0;
    return Scaffold(
      backgroundColor: kPink.withOpacity(0.2),
      appBar: AppBar(
        title: Text('Review Cart'),
        centerTitle: true,
        backgroundColor: kPink,
      ),
      body: Container(

        height: double.infinity,
        width: double.infinity,
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(

              child: Container(
                child: ListView.builder(

                    itemCount: Provider.of<ProductProvider>(context).cartList.length,
                    itemBuilder: (context,index){
                      return CartListTile(
                        limage: Provider.of<ProductProvider>(context).cartList[index].ProductImages,
                        lname: Provider.of<ProductProvider>(context).cartList[index].ProductName,
                        lprice: Provider.of<ProductProvider>(context).cartList[index].totalPrice(),
                        lquantity: Provider.of<ProductProvider>(context).cartList[index].ProductQuantity,

                      );
                    }),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Delivery Charges : ${Provider.of<ProductProvider>(context).getTotalDelivery()} Rs',style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),),
                  Text('Total Amount : ${Provider.of<ProductProvider>(context).getTotalAmount()+Provider.of<ProductProvider>(context).getTotalDelivery()} Rs',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),)
                ],
              ),
            ),


            Padding(
              padding: const EdgeInsets.only(bottom: 10.0, right: 10),
              child: InkWell(
                onTap: () {
                  if(Provider.of<ProductProvider>(context,listen: false).cartList.isNotEmpty){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DeliveryDetails(
                          )
                      ),
                    );
                  }

                },
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 100,vertical: 15),
                    decoration: BoxDecoration(
                      color: kPink.withOpacity(0.4),
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                    ),
                    child: const Text(
                      "   Proceed   ",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: kPurple,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(15.0),
            //   child: RoundedButton(colour: kPink.withOpacity(0.4), buttonTitle: 'Place Order', onPressedFunction: ()async{
            //     await Provider.of<ProductProvider>(context,listen: false).setcartdata();
            //     Provider.of<ProductProvider>(context,listen: false).cartList=[];
            //     Provider.of<ProductProvider>(context,listen: false).getCartData();
            //     Provider.of<ProductProvider>(context,listen: false).notifyListeners();
            //   }, Elevation: 10),
            // )
          ],
        ),
      ),
    );
  }
}
