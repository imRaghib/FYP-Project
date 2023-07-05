class ProductOrder {

  String ProductImages;
  String ProductName;
  int ProductQuantity;
  int ProductPrice;
  String size;
  int deliveryCharges;
  String buyerId;
  String sellerId;


  ProductOrder({
    this.ProductImages='',
    this.ProductName='',
    this.ProductPrice=0,
    this.ProductQuantity=0,
    this.size='Custom',
    this.buyerId='',
    this.deliveryCharges=0,
    this.sellerId=''

  });

  int totalPrice(){
    return ProductQuantity * ProductPrice;
  }
}
