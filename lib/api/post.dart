class Post {
  final String postdesc;
  final String date;
  final String sender;
  final String imgurl;

  Post(this.postdesc, this.date, this.sender, this.imgurl);
  Post.fromJson(Map<dynamic, dynamic> json)
      : date = DateTime.parse(json['date']).toString(),
        postdesc = json['postdesc'] as String,
        sender = json['sender'] as String,
        imgurl = json['imgurl'] as String;

  Map<dynamic, dynamic> tojson() => <dynamic, dynamic>{
        'date': date.toString(),
        'postdesc': postdesc.toString(),
        'sender': sender.toString(),
        'imgurl': imgurl.toString()
      };
}
