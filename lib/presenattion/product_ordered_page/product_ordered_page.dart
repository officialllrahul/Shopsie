import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopsie/presenattion/dashboard/dashboard.dart';

class ProductOrderedPage extends StatefulWidget {
  const ProductOrderedPage({Key? key, required this.data}) : super(key: key);

  final Map<String, dynamic>? data;
  @override
  State<ProductOrderedPage> createState() => _ProductOrderedPageState();
}

class _ProductOrderedPageState extends State<ProductOrderedPage> {
  String _formatDateTime(DateTime? dateTime) {
    if (dateTime != null) {
      final formatter = DateFormat('MMMM d, y - HH:mm:ss');
      return formatter.format(dateTime);
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Details Page"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const dashBoard()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Card(
            margin: const EdgeInsets.all(16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Show the image or a placeholder icon if the image URL is null
                  widget.data?['p_image'] != null
                      ? Image.network(
                          widget.data?['p_image'] ?? '',
                          width: 300,
                          height: 300,
                          fit: BoxFit.contain,
                        )
                      : const Icon(Icons.image, size: 100),

                  const SizedBox(height: 16),
                  Text(widget.data?['p_name'] ?? 'Placeholder Title',
                      style:
                          const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                  const SizedBox(height: 2),
                  // Text(
                  //     widget.data?['product_subtitle'] ??
                  //         'Placeholder subtitle',
                  //     style:
                  //         const TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
                  const SizedBox(height: 2),

                  Container(
                    margin: const EdgeInsets.all(2),
                    child: Text(widget.data?['p_description'] ??
                        'Placeholder Description'),
                  ),
                  const SizedBox(height: 2),
                  // Container(
                  //   margin: const EdgeInsets.all(2),
                  //   child: RichText(
                  //     text: TextSpan(
                  //       style: DefaultTextStyle.of(context).style,
                  //       children: [
                  //         const TextSpan(
                  //           text: "Size: ",
                  //           style: TextStyle(
                  //               fontWeight: FontWeight.bold, fontSize: 16),
                  //         ),
                  //         // TextSpan(
                  //         //   text: widget.data?['product_size'] ??
                  //         //       'Placeholder Size',
                  //         //   style: const TextStyle(fontSize: 16),
                  //         // ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(height: 2),
                  Container(
                    margin: const EdgeInsets.all(2),
                    child: Text(
                      "Total Amount: ₹ ${widget.data?['total_price'] ?? ''}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    margin: const EdgeInsets.all(2),
                    child: Text(
                      "Date: ${_formatDateTime(widget.data?['timestamp']?.toDate() as DateTime)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
