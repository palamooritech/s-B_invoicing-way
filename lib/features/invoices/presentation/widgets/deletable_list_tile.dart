import 'package:flutter/material.dart';
import 'package:invoicing_sandb_way/core/theme/app_pallette.dart';

class DeletableListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onDelete;

  const DeletableListTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(title), // Unique key for each Dismissible widget
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerRight,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Confirm", style: TextStyle(
                color: AppPallete.primaryFontColor
              ),),
              content: const Text("Are you sure you want to delete this item?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("CANCEL"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text("DELETE"),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        onDelete(); // Callback to handle item deletion
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 3, // Adjust the elevation if needed
        child: ListTile(
          title: Text(title),
          subtitle: Text(subtitle),
          tileColor: Colors.white, // Replace with AppPallete.whiteColor if needed
          leading: const Icon(Icons.drag_handle),
          onTap: () {
            // Handle tap if needed
          },
        ),
      ),
    );
  }
}
