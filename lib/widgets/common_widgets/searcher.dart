import 'package:flutter/material.dart';

class Searcher extends StatelessWidget {
  const Searcher({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 35,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.deepOrange, width: 1.4),
          borderRadius: BorderRadius.circular(25),
        ),
        child: InkWell(
          onTap: (){},
          child: const Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Icon(Icons.search, color: Colors.grey),
              ),
              Text('Find Food to add', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}