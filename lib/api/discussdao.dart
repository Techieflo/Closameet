import 'package:firebase_database/firebase_database.dart';

DatabaseReference referenceData = FirebaseDatabase.instance.ref('discussion');
Query getdiscuss() {
  return referenceData;
}
