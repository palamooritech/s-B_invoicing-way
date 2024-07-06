import 'package:flutter/material.dart';
import 'package:invoicing_sandb_way/core/theme/app_pallette.dart';

class CustomCard extends StatefulWidget {
  final String title;
  final double totalAmount;
  final String date;
  final String status;
  final String userName;
  final String userPicUrl;
  final String buttonText;
  final VoidCallback onButtonPressed;

  CustomCard({
    required this.title,
    required this.totalAmount,
    required this.date,
    required this.status,
    required this.userName,
    required this.userPicUrl,
    required this.buttonText,
    required this.onButtonPressed,
  });

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  late String imgPath;

  @override
  void initState() {
    super.initState();
    imgPath = widget.userPicUrl.isEmpty? "https://static.independent.co.uk/2024/04/23/21/2024-04-23T201831Z_1772745914_UP1EK4N1KET6J_RTRMADP_3_SOCCER-ENGLAND-ARS-CHE-REPORT.JPG": widget.userPicUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      color: AppPallete.cardColor1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // First row with title and total amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '₹ ${widget.totalAmount.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            // Second row with date and status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  widget.date,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  decoration: BoxDecoration(
                    color: widget.status == 'Approved'
                        ? Colors.green
                        : widget.status == 'Reviewing'
                        ? Colors.orange
                        : Colors.red,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Text(
                    widget.status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            const Divider(),
            const SizedBox(height: 8.0),
            // Fourth row with user info and button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: NetworkImage(imgPath),
                      radius: 20.0,
                    ),
                    const SizedBox(width: 10.0),
                    Text(
                      widget.userName,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: widget.onButtonPressed,
                  style: ElevatedButton.styleFrom(
                    elevation: 5.0,
                  ),
                  child: Text(widget.buttonText),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
