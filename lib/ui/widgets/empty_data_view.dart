import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptyDataView extends StatelessWidget {
  final String message;

  const EmptyDataView({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset('assets/lottie/85023-no-data.json',
              height: MediaQuery.of(context).size.height / 3),
          Text(message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
