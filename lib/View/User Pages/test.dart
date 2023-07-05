// import 'package:flutter/material.dart';
//
// class BillingFormScreen extends StatefulWidget {
//   @override
//   _BillingFormScreenState createState() => _BillingFormScreenState();
// }
//
// class _BillingFormScreenState extends State<BillingFormScreen> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//   final TextEditingController _cardNumberController = TextEditingController();
//   final TextEditingController _expiryController = TextEditingController();
//   final TextEditingController _cvvController = TextEditingController();
//
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//
//   String _selectedCardType = 'Credit Card';
//   List<String> _cardTypes = ['Credit Card', 'Debit Card'];
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _addressController.dispose();
//     _cardNumberController.dispose();
//     _expiryController.dispose();
//     _cvvController.dispose();
//     super.dispose();
//   }
//
//   void _submitForm() {
//     if (_formKey.currentState!.validate()) {
//       // Form is valid, process the data
//       final String name = _nameController.text;
//       final String email = _emailController.text;
//       final String address = _addressController.text;
//       final String cardNumber = _cardNumberController.text;
//       final String expiry = _expiryController.text;
//       final String cvv = _cvvController.text;
//       final String cardType = _selectedCardType;
//
//       // Perform further processing with the form data here
//
//       // Clear the form fields
//       _nameController.clear();
//       _emailController.clear();
//       _addressController.clear();
//       _cardNumberController.clear();
//       _expiryController.clear();
//       _cvvController.clear();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Billing Form'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 TextFormField(
//                   controller: _nameController,
//                   decoration: const InputDecoration(
//                     labelText: 'Name',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your name';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16.0),
//                 TextFormField(
//                   controller: _emailController,
//                   decoration: const InputDecoration(
//                     labelText: 'Email',
//                     border: OutlineInputBorder(),
//                   ),
//                   keyboardType: TextInputType.emailAddress,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your email';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16.0),
//                 TextFormField(
//                   controller: _addressController,
//                   decoration: const InputDecoration(
//                     labelText: 'Address',
//                     border: OutlineInputBorder(),
//                   ),
//                   maxLines: 3,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your address';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16.0),
//                 TextFormField(
//                   controller: _cardNumberController,
//                   decoration: const InputDecoration(
//                     labelText: 'Card Number',
//                     border: OutlineInputBorder(),
//                   ),
//                   keyboardType: TextInputType.number,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your card number';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16.0),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: DropdownButtonFormField<String>(
//                         value: _selectedCardType,
//                         items: _cardTypes.map((String cardType) {
//                           return DropdownMenuItem<String>(
//                             value: cardType,
//                             child: Text(cardType),
//                           );
//                         }).toList(),
//                         onChanged: (String? value) {
//                           setState(() {
//                             _selectedCardType = value!;
//                           });
//                         },
//                         decoration: const InputDecoration(
//                           labelText: 'Card Type',
//                           border: OutlineInputBorder(),
//                         ),
//                         isExpanded: true, // Added line
//                       ),
//                     ),
//                     const SizedBox(width: 16.0),
//                     Expanded(
//                       child: TextFormField(
//                         controller: _expiryController,
//                         decoration: const InputDecoration(
//                           labelText: 'Expiry',
//                           border: OutlineInputBorder(),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter expiry';
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                     const SizedBox(width: 16.0),
//                     Expanded(
//                       child: TextFormField(
//                         controller: _cvvController,
//                         decoration: const InputDecoration(
//                           labelText: 'CVV',
//                           border: OutlineInputBorder(),
//                         ),
//                         keyboardType: TextInputType.number,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter CVV';
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16.0),
//                 MaterialButton(
//                   child: const Text('Submit'),
//                   onPressed: _submitForm,
//                   color: Colors.blue,
//                   textColor: Colors.white,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class ImageSlider extends StatefulWidget {
  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  final List<String> images = [
    'https://media.istockphoto.com/id/872361244/photo/man-getting-his-beard-trimmed-with-electric-razor.jpg?s=612x612&w=0&k=20&c=_IjZcrY0Gp-2z6AWTQederZCA9BLdl-iqWkH0hGMTgg='
  ];

  final List<String> descriptions = ['Add your descriptions here'];

  double _scrollOffset = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView.builder(
            itemCount: images.length,
            scrollDirection: Axis.horizontal,
            physics: PageScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                width: MediaQuery.of(context).size.width,
                child: Image.network(images[index], fit: BoxFit.cover),
              );
            },
            // onScrollNotification: (notification) {
            //   if (notification is ScrollUpdateNotification) {
            //     setState(() {
            //       _scrollOffset += notification.scrollDelta!;
            //     });
            //   }
            //   return false;
            // },
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 20.0,
            child: Transform.translate(
              offset: Offset(_scrollOffset, 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: descriptions.map((description) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text(
                      description,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
