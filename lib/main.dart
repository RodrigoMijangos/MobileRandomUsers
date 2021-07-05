import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp(users: getUsers()));

/// This is the main application widget.
class MyApp extends StatelessWidget {

  final Future<User> users;

  MyApp({Key? key, required this.users}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
        title: const Text('Sample Code'),
      ),
      body: Center(
        child: FutureBuilder<User>(
          future: users,
          builder: (context, snapshot){
            if(snapshot.hasData){
               
              return ListView.builder(
                itemCount: snapshot.data!.results.length,
                itemBuilder: (BuildContext context, int index){
                  String gender = snapshot.data!.results.elementAt(index).gender;
                  return Card(
                    child: ListTile(
                      tileColor: gender == 'male' ? Colors.blue[100] : Colors.pink[100],
                      leading: ImageViewCustom(URL: snapshot.data!.results.elementAt(index).picture.thumbnail),
                      title: Text("${snapshot.data!.results.elementAt(index).name.title}"+
                      "${snapshot.data!.results.elementAt(index).name.first}"+
                      "${snapshot.data!.results.elementAt(index).name.last}"),
                      subtitle: Text('Username: ${snapshot.data!.results.elementAt(index).login.username}.' +
                      ' Email: ${snapshot.data!.results.elementAt(index).email}.'+
                      ' Phone: ${snapshot.data!.results.elementAt(index).phone}'),
                      ),
                  );
                },
              );
            }else if(snapshot.hasError){
              return Text("${snapshot.error}");
            }
            throw Exception();
          },
        )
      )
      ),
    );
  }
}

class ImageViewCustom extends StatelessWidget{
  
  const ImageViewCustom({
    Key? key,
    required this.URL
  }): super(key: key);

  final String URL;
  
  @override
  Widget build(BuildContext context) {
    print(URL);
    return Image(
      image: NetworkImage(this.URL),
    );
  }

}

Future<User> getUsers() async{
  const URL = 'https://randomuser.me/api/?results=100';
  final resp = await http.get(Uri.parse(URL));

  if(resp.statusCode == 200){
    return User.fromJson(json.decode(resp.body));
  }

  throw Exception('Failed to load Users');
}

class User {
  User({
    required this.results
  });

  List<Result> results;

  factory User.fromJson(Map<String, dynamic> json) => User(
        results: List<Result>.from(json["results"].map((x) => Result.fromJson(x)))
    );
     Map<String, dynamic> toJson() => {
        "results": List<dynamic>.from(results.map((x) => x.toJson()))
    };
}

class Result {
    Result({
        required this.gender,
        required this.name,
        required this.email,
        required this.login,
        required this.phone,
        required this.picture
    });

    String gender;
    Name name;
    String email;
    Login login;
    String phone;
    Picture picture;

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        gender: json["gender"],
        name: Name.fromJson(json["name"]),
        email: json["email"],
        login: Login.fromJson(json["login"]),
        phone: json["phone"],
        picture: Picture.fromJson(json["picture"])
    );

    Map<String, dynamic> toJson() => {
        "gender": gender,
        "name": name.toJson(),
        "email": email,
        "login": login.toJson(),
        "phone": phone,
        "picture": picture.toJson(),
    };
}

class Login {
    Login({
        required this.username
    });

    String username;

    factory Login.fromJson(Map<String, dynamic> json) => Login(
        username: json["username"]
    );

    Map<String, dynamic> toJson() => {
        "username": username
    };
}

class Name {
    Name({
        required this.title,
        required this.first,
        required this.last,
    });

    String title;
    String first;
    String last;

    factory Name.fromJson(Map<String, dynamic> json) => Name(
        title: json["title"],
        first: json["first"],
        last: json["last"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "first": first,
        "last": last,
    };
}

class Picture {
    Picture({
        required this.large,
        required this.medium,
        required this.thumbnail,
    });

    String large;
    String medium;
    String thumbnail;

    factory Picture.fromJson(Map<String, dynamic> json) => Picture(
        large: json["large"],
        medium: json["medium"],
        thumbnail: json["thumbnail"],
    );

    Map<String, dynamic> toJson() => {
        "large": large,
        "medium": medium,
        "thumbnail": thumbnail,
    };
}



/// This is the private State class that goes with MyStatefulWidget.
/* class _MyStatefulWidgetState extends State<MyStatefulWidget> {

  final items = List<String>.generate(10000, (index) => "Item $index");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample Code'),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 50,
              color: Colors.amberAccent,
              child: Center(
                child: ListTile(
                  leading: FlutterLogo(),
                  title: Text('Entrada: ${items[index]}'),
                ),
              ),
            );
          }
        )
      )
    );
  }
}
 */