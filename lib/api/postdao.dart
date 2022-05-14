import 'package:firebase_database/firebase_database.dart';

DatabaseReference referenceData = FirebaseDatabase.instance.ref('posts');
Query getposts() {
  return referenceData;
}
