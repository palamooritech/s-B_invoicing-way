import 'package:flutter/material.dart';
import 'package:invoicing_sandb_way/core/theme/app_pallette.dart';

class FloatingBottomNavBar extends StatefulWidget {
  final ValueChanged<int> onItemTapped;
  final bool flag;

  FloatingBottomNavBar({
    required this.onItemTapped,
    required this.flag,
  });

  @override
  _FloatingBottomNavBarState createState() => _FloatingBottomNavBarState();
}

class _FloatingBottomNavBarState extends State<FloatingBottomNavBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      widget.onItemTapped(index);  // Callback to parent class
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: PhysicalModel(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(30.0),
        elevation: 8.0,
        shadowColor: Colors.black.withOpacity(0.3),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.0),
          child: Container(
            decoration: BoxDecoration(
              color: AppPallete.gradient1,  // Adjust the opacity to make it semi-transparent
              border: Border.all(color: Colors.grey.shade300, width: 1.0),
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: BottomAppBar(
              shape: const CircularNotchedRectangle(),
              notchMargin: 6.0,
              color: Colors.transparent,  // Set BottomAppBar color to transparent
              elevation: 0.0,  // Remove elevation from BottomAppBar
              child: Container(
                height: 60.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: widget.flag? const Icon(Icons.monetization_on, size: 30,):const Icon(Icons.receipt),
                          color: _selectedIndex == 0 ? AppPallete.gradient2 : Colors.grey,
                          onPressed: () => _onItemTapped(0),
                        ),
                        const SizedBox(height: 5,),
                        InkWell(
                          onTap: () => _onItemTapped(0),
                          child: Text(
                            widget.flag ? 'Bills' : 'Invoices',
                            style: TextStyle(
                                color: _selectedIndex == 0 ? AppPallete.gradient2 : Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.person, size: 30,),
                          color: _selectedIndex == 1 ? AppPallete.gradient2 : Colors.grey,
                          onPressed: () => _onItemTapped(1),
                        ),
                        const SizedBox(height: 5,),
                        InkWell(
                          onTap: () => _onItemTapped(1),
                          child: Text('Account',style: TextStyle(
                              color: _selectedIndex == 1 ? AppPallete.gradient2 : Colors.grey,
                              fontSize: 16,
                            fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}