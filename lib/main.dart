import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:yo/finished/finished_friends_model.dart';
import 'package:yo/friends_model.dart';
import 'package:yo/person.dart';
import 'package:yo/session_model.dart';

Future<void> main() async {
  final SessionModel sessionModel = SessionModel();

  runApp(ScopedModel<SessionModel>(
    model: sessionModel,
    child: YoApp(),
  ));
}

class YoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yo!',
      theme: ThemeData(
        brightness: Brightness.dark,
        accentColor: Color(0xFFF67280),
      ),
      home: Scaffold(
        body: ScopedModelDescendant<SessionModel>(
          builder: (BuildContext context, Widget child, SessionModel model) {
            if (!model.initialized) {
              return Container(
                color: Color(0xFF6C5B7B),
                child: Center(
                  child: SizedBox(
                    width: 48,
                    height: 48,
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            }

            if (model.isUserLoggedIn) {
              // register a Page-scope based model
              return ScopedModel<FriendsModel>(
                model: FriendsModel(model),
                child: FriendsListPage(),
              );
            } else {
              return LoginPage();
            }
          },
        ),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF6C5B7B),
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: Text("Yo!", style: Theme.of(context).textTheme.display4),
              ),
            ),
            RaisedButton(
              child: Text("Google Login"),
              onPressed: () {
                print("login");
                final SessionModel model =
                    ScopedModel.of<SessionModel>(context);
                model.googleLogin();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class FriendsListPage extends StatefulWidget {
  @override
  _FriendsListPageState createState() => _FriendsListPageState();
}

class _FriendsListPageState extends State<FriendsListPage> {
  List<Color> _colors = [
    Color(0xFFF8B195),
    Color(0xFFF67280),
    Color(0xFFC06C84),
    Color(0xFF6C5B7B),
    Color(0xFF355C7D),
    Color(0xFF34495D),
  ];

  Widget _createListItem(Person person, Color color) {
    return Material(
      color: color,
      child: InkWell(
        onTap: () {
          print('Tapped ${person.name}');
          FriendsModel.of(context).sendYo(person);
        },
        child: Container(
          height: 128,
          alignment: Alignment.centerLeft,
          child: ListTile(
            leading: ClipRRect(
              child: Image.network(
                person.photoUrl,
                height: 56,
                width: 56,
              ),
              borderRadius: BorderRadius.circular(28),
            ),
            title: Text(
              person.name.toUpperCase(),
              maxLines: 1,
              style: Theme.of(context).textTheme.display1.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.0,
                    fontSize: 28,
                  ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Access the model an register for changes. This will make call the
    // ScopedModelDescendant.builder function again
    return ScopedModelDescendant<FriendsModel>(
      builder: (BuildContext context, Widget child, FriendsModel model) {
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return _createListItem(model.friends[index], _colors[index % 5]);
          },
          itemCount: model.friends.length,
        );
      },
    );
  }
}
