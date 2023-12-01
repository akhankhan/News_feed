import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart' as awesome;

class SnackbarUtils {
  static void showAwesomeSnackBar(BuildContext context, String title, String message, awesome.ContentType contentType) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: awesome.AwesomeSnackbarContent( // Use the 'awesome' prefix
        title: title,
        message: message,
        contentType: contentType,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}

// Now you can uncomment this part and use 'awesome.ContentType' explicitly
// enum ContentType {
//   success,
//   error,
//   warning,
//   // Add more content types as needed
// }

// class AwesomeSnackbarContent extends StatelessWidget {
//   final String title;
//   final String message;
//   final awesome.ContentType contentType; // Use the 'awesome' prefix

//   const AwesomeSnackbarContent({
//     required this.title,
//     required this.message,
//     required this.contentType,
//   });

//   @override
//   Widget build(BuildContext context) {
//     Color backgroundColor;
//     Icon icon;

//     switch (contentType) {
//       case awesome.ContentType.success: // Use the 'awesome' prefix
//         backgroundColor = Colors.green;
//         icon = Icon(Icons.check, color: Colors.white);
//         break;
//       case awesome.ContentType.error: // Use the 'awesome' prefix
//         backgroundColor = Colors.red;
//         icon = Icon(Icons.error, color: Colors.white);
//         break;
//       case awesome.ContentType.warning: // Use the 'awesome' prefix
//         backgroundColor = Colors.amber;
//         icon = Icon(Icons.warning, color: Colors.white);
//         break;
//     }

//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       decoration: BoxDecoration(
//         color: backgroundColor,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         children: [
//           icon,
//           SizedBox(width: 8),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
//               ),
//               Text(
//                 message,
//                 style: TextStyle(color: Colors.white),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
