// import 'package:flutter/material.dart';

// class PaymentScreen extends StatefulWidget {
//   const PaymentScreen({super.key});

//   @override
//   State<PaymentScreen> createState() => _PaymentScreenState();
// }

// class _PaymentScreenState extends State<PaymentScreen> {

//   String payment = "cod";

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Payment"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [

//             /// CASH ON DELIVERY
//             ListTile(
//               leading: const Icon(Icons.local_shipping),
//               title: const Text("Cash On Delivery"),
//               trailing: Radio(
//                 value: "cod",
//                 groupValue: payment,
//                 onChanged: (v){
//                   setState(() {
//                     payment = v!;
//                   });
//                 },
//               ),
//             ),

//             const Divider(),

//             /// ONLINE PAY
//             ListTile(
//               leading: const Icon(Icons.attach_money),
//               title: const Text("Online Pay"),
//               trailing: Radio(
//                 value: "online",
//                 groupValue: payment,
//                 onChanged: (v){
//                   setState(() {
//                     payment = v!;
//                   });
//                 },
//               ),
//             ),

//             const SizedBox(height: 20),

//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [

//                 Image.asset("assets/images/aba.png", width: 70),
//                 Image.asset("assets/images/ac.png", width: 70),
//                 Image.asset("assets/images/kana.png", width: 70),

//               ],
//             ),

//             const Spacer(),

//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 minimumSize: const Size(double.infinity, 50),
//               ),
//               onPressed: (){
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text("Payment Successful")),
//                 );
//               },
//               child: const Text("Confirm Payment"),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {

  final String selectedMethod;

  const PaymentScreen({
    super.key,
    required this.selectedMethod,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {

  late String method;

  @override
  void initState() {
    method = widget.selectedMethod;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Payment")),

      body: Column(
        children: [

          ListTile(
            leading: const Icon(Icons.local_shipping),
            title: const Text("Cash On Delivery"),
            trailing: Radio(
              value: "Cash On Delivery",
              groupValue: method,
              onChanged: (v) {
                setState(() => method = v!);
              },
            ),
          ),

          ListTile(
            leading: const Icon(Icons.attach_money),
            title: const Text("Online Pay"),
            trailing: Radio(
              value: "Online Pay",
              groupValue: method,
              onChanged: (v) {
                setState(() => method = v!);
              },
            ),
          ),

          const Spacer(),

          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {

                Navigator.pop(context, method);

              },
              child: const Text("Confirm Payment"),
            ),
          )
        ],
      ),
    );
  }
}