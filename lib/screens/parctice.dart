import 'dart:async';

import 'package:flutter/material.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Practice Excercise"),
      ),
      body: Column(
        children: [
          const Center(
            child: Text(
              "Future Builder practice",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
          const Text(
            "My Name Is ",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          StreamBuilder(
            stream: getSTreams(),
            builder: (context, AsyncSnapshot<List> snapshot) =>
                ListView.builder(
                    itemCount: snapshot.data!.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Text(
                        snapshot.data![index].toString(),
                        style: const TextStyle(color: Colors.white),
                      );
                    }),
          )
        ],
      ),
    );
  }

  Stream<List> getSTreams() async* {
    List a = [];
    for (int i = 0; i < 10; i++) {
      Future.delayed(const Duration(seconds: 2));
      a.add(i);
      yield a;
    }
  }
}
