import 'package:flutter/material.dart';

import 'constants.dart';

class ErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error,
                size: 45,
                color: Colors.white.withOpacity(.6),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Something wants wrong!",
                style: heading.copyWith(color: Colors.white.withOpacity(.9)),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "We so sorry about the error.please try again later.",
                textAlign: TextAlign.center,
                style: normalText.copyWith(color: Colors.white.withOpacity(.9)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
