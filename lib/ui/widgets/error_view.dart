import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ErrorView extends StatelessWidget {
  final Function? _refresh;

  const ErrorView({super.key, Function? refresh}) : _refresh = refresh;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset('assets/lottie/12955-no-internet-connection.json',
              height: MediaQuery.of(context).size.height / 3),
          const SizedBox(height: 10),
          const Text("Oops Something Wrong!"),
          if (_refresh != null) const SizedBox(height: 5),
          TextButton(
            onPressed: _refresh!(),
            child: const Text("Retry"),
          )
        ],
      ),
    );
  }
}
