import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
          const Text("Oops Something Wrong!")
              .animate()
              .fade(
                duration: 850.ms,
              )
              .slideX(
                begin: -0.3,
                duration: 1200.ms,
                curve: Curves.fastOutSlowIn,
              ),
          if (_refresh != null) const SizedBox(height: 5),
          TextButton(
            onPressed: _refresh!(),
            child: const Text("Retry"),
          )
              .animate()
              .fade(
                duration: 850.ms,
              )
              .slideX(
                begin: 0.3,
                duration: 1200.ms,
                curve: Curves.fastOutSlowIn,
              )
        ],
      ),
    );
  }
}
