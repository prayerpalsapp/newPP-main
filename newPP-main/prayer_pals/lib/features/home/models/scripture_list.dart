import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:prayer_pals/core/utils/size_config.dart';

class GetScripture extends HookWidget {
  const GetScripture({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const int length =
        110; // Total number of scriptures. Can improve method later.
    final int randomScriptureInt = Random().nextInt(length);
    final documentId = randomScriptureInt.toString();
    CollectionReference scriptures =
        FirebaseFirestore.instance.collection('scriptures');

    return FutureBuilder<DocumentSnapshot>(
      future: scriptures.doc(documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Column(
            children: [
              Text(
                data['verse'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Helvetica',
                  fontSize: SizeConfig.safeBlockVertical! * 2.5,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(
                height: SizeConfig.safeBlockVertical! * 2,
              ),
              Text(
                data['ref'],
                style: TextStyle(
                  fontFamily: 'Helvetica',
                  fontSize: SizeConfig.safeBlockVertical! * 3,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          );
        }

        return const Text("loading");
      },
    );
  }
}
