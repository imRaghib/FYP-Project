import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shaadi/View/User%20Pages/order_history_detail.dart';
import 'package:easy_shaadi/ViewModel/providerclass.dart';
import 'package:easy_shaadi/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as intl;
class OrderHistory extends StatelessWidget {
  const OrderHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
        centerTitle: true,
        backgroundColor: kPink,
      ),
      body: StreamBuilder(
        stream: Provider.of<ProductProvider>(context).getAllOrders(),
          builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator());
          }
          else if(snapshot.data!.docs.isEmpty){
            return Center(child: Text('No Orders Yet'));
          }
          else{
            dynamic data = snapshot.data!.docs;
            return ListView.builder(
              itemCount: data.length,
                itemBuilder: (BuildContext context,int index){
                  var d= data[index]['order_date'] as Timestamp;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(15),
                    child: ListTile(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderDetails(data: data[index],)
                          ),
                        );
                      },
                        
                      leading: Image(image: NetworkImage(data[index]['orderlist'][0]['ProductImage'])),
                      title: Text('Order id : '+data[index]['order_id'].toString(),style: TextStyle(
                        color: Colors.red,fontWeight: FontWeight.bold,fontSize: 16
                      ),),
                      subtitle: Text('Total Amount : '+data[index]['total_amount'].toString()+' Rs'),
                      trailing: Text('${intl.DateFormat().add_yMd().format(d.toDate())}'),
                    ),
                  )

                );
                }
            );
          }
          }
      ),
    );
  }
}
