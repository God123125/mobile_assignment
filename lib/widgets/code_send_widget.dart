import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 

// class CodeBoxWidget extends StatelessWidget {
//   final TextEditingController controller;
//   final FocusNode focusNode;
//   final FocusNode? nextFocus;
//   final FocusNode? previousFocus;

//   const CodeBoxWidget({
//     super.key,
//     required this.controller,
//     required this.focusNode,
//     this.nextFocus,
//     this.previousFocus,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 60,
//       height: 60,
//       alignment: Alignment.center,
//       decoration: BoxDecoration(
//         color: const Color(0xFFF0F5FA),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: TextField(
//         controller: controller,
//         focusNode: focusNode,
//         keyboardType: TextInputType.number,
//         textAlign: TextAlign.center,
//         maxLength: 1,
//         style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//         inputFormatters: [
//           FilteringTextInputFormatter.digitsOnly,
//         ],
//         decoration: const InputDecoration(
//           counterText: '',
//           border: InputBorder.none,
//           hintStyle: TextStyle(color: Colors.grey),
//         ),
//         onChanged: (value) {
//           if (value.length == 1) {
//             // Move to next box
//             if (nextFocus != null) {
//               FocusScope.of(context).requestFocus(nextFocus);
//             } else {
//               focusNode.unfocus(); // Last box
//             }
//           } else if (value.isEmpty) {
//             // If deleted, move back
//             if (previousFocus != null) {
//               FocusScope.of(context).requestFocus(previousFocus);
//             }
//           }
//         },
//       ),
//     );
//   }
// }
class CodeBoxWidget extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextFocus;
  final FocusNode? previousFocus;
  final VoidCallback? onCompleted; // 👈 NEW

  const CodeBoxWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    this.nextFocus,
    this.previousFocus,
    this.onCompleted, // 👈 NEW
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F5FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
        onChanged: (value) {
          if (value.length == 1) {
            if (nextFocus != null) {
              FocusScope.of(context).requestFocus(nextFocus);
            } else {
              focusNode.unfocus();
              onCompleted?.call(); // 🚀 AUTO VERIFY
            }
          } else if (value.isEmpty && previousFocus != null) {
            FocusScope.of(context).requestFocus(previousFocus);
          }
        },
      ),
    );
  }
}
