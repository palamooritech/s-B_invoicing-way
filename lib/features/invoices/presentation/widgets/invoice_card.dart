import 'package:flutter/material.dart';
import 'package:invoicing_sandb_way/core/theme/app_pallette.dart';

class InvoiceCard extends StatefulWidget {
  final String title;
  final Widget content;
  final String status;
  final int totalCost;
  final Color color;

  InvoiceCard({
    Key? key,
    required this.title,
    required this.content,
    required this.status,
    required this.totalCost,
    required this.color,
  }) : super(key: key);

  @override
  State<InvoiceCard> createState() => _InvoiceCardState();
}

class _InvoiceCardState extends State<InvoiceCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {

    return Card(
      color: widget.color,
      child: InkWell(
        onTap: () => setState(() => _isExpanded = !_isExpanded),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListTile(
                contentPadding: const EdgeInsets.all(0.0), // Remove padding
                leading: Icon(
                    Icons.album,
                  size: 25,
                  color: widget.status == "Reviewing"? Colors.yellow: widget.status == "Approved" ? Colors.green: Colors.red,
                ),
                title: Text(
                  widget.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text("Status : ", style: TextStyle(
                              fontWeight: FontWeight.w700
                            ),),
                            const SizedBox(width: 3,),
                            Text(widget.status),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.money, size: 30,),
                            const SizedBox(width: 3,),
                            Text('${widget.totalCost} INR',style: const TextStyle(
                              color: AppPallete.gradient1,
                              fontWeight: FontWeight.w700,
                            ),),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: _isExpanded
                    ? Icon(Icons.keyboard_arrow_up) // Up arrow when expanded
                    : Icon(Icons.keyboard_arrow_down), // Down arrow when collapsed
              ),
            ),
            if (_isExpanded) widget.content, // Display content only when expanded
          ],
        ),
      ),
    );
  }
}
