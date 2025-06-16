// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SearchToggleWidget extends StatelessWidget {
  final bool showSearch;
  final TextEditingController searchController;
  final VoidCallback onToggle;

  const SearchToggleWidget({
    Key? key,
    required this.showSearch,
    required this.searchController,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) => SizeTransition(
        sizeFactor: animation,
        axis: Axis.horizontal,
        child: child,
      ),
      child: showSearch
          ? SizedBox(
              key: const ValueKey('search_field'),
              width: 300,
              child: TextField(
                controller: searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'ค้นหา...',
                  isDense: true,
                  contentPadding: const EdgeInsets.all(10),
                  filled: true,  
                  fillColor: const Color(0xFFF6F6F6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: onToggle,
                  ),
                ),
              ),
            )
          : IconButton(
              key: const ValueKey('search_icon'),
              icon: const Icon(
                FontAwesomeIcons.magnifyingGlass,
                color: Colors.black,
              ),
              onPressed: onToggle,
            ),
    );
  }
}
