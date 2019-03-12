import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:yo/finished/finished_friends_model.dart';
import 'package:yo/finished/finished_session_model.dart';
import 'package:yo/person.dart';

class FriendsPage extends StatefulWidget {
  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  FinishedFriendsModel model;

  @override
  Widget build(BuildContext context) {
    final userModel =
        ScopedModel.of<FinishedSessionModel>(context, rebuildOnChange: false);
    if (model == null || model.sessionModel != userModel) {
      model = FinishedFriendsModel(userModel);
    }
    return ScopedModel<FinishedFriendsModel>(
      model: model,
      child: _FriendsPageContent(),
    );
  }
}

class _FriendsPageContent extends StatefulWidget {
  static const ROUTE_NAME = "/home";

  @override
  _FriendsPageStateContent createState() => _FriendsPageStateContent();
}

class _FriendsPageStateContent extends State<_FriendsPageContent>
    with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  List<Color> _colors = [
    Color(0xFFF8B195),
    Color(0xFFF67280),
    Color(0xFFC06C84),
    Color(0xFF6C5B7B),
    Color(0xFF355C7D),
    Color(0xFF34495D),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xFF6C5B7B),
      body: _buildListView(),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFFF67280),
          child: Icon(Icons.share),
          onPressed: () => _showSnackbar(
              "Please tell your friends about this app in real life 💬")),
    );
  }

  Widget _buildListItem(Person person, Color color) {
    return Material(
      color: color,
      child: InkWell(
        onTap: () {
          FinishedFriendsModel.of(context).sendYo(person).then((_) {
            _showSnackbar("Yo sent to ${person.name} ✌");
          }).catchError((e) {
            if (e is SpammyException) {
              _showSnackbar("Whoa! You can't play the yo-yo all the time 💥");
            } else {
              _showSnackbar("Something went wrong sending Yo!");
            }
          });
        },
        child: Container(
          height: 120,
          padding: EdgeInsets.all(24),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.network(person.photoUrl, width: 48, height: 48)),
              SizedBox(width: 24),
              Flexible(
                child: Text(
                  person.possibleFirstName(),
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .title
                      .copyWith(fontSize: 32, letterSpacing: 2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListView() {
    return ScopedModelDescendant<FinishedFriendsModel>(
      builder:
          (BuildContext context, Widget child, FinishedFriendsModel model) {
        if (model.isLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return ListView.builder(
          itemBuilder: (context, index) {
            if (index >= model.friends.length) {
              return _logoutButton();
            }
            return _buildListItem(
                model.friends[index], _colors[(index + 2) % 6]);
          },
          itemCount: model.friends.length + 1,
        );
      },
    );
  }

  Widget _logoutButton() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RaisedButton(
          onPressed: () {
            ScopedModel.of<FinishedSessionModel>(context).logout();
          },
          child: Text("Logout",
              style: Theme.of(context)
                  .textTheme
                  .title
                  .copyWith(fontSize: 24, letterSpacing: 2)),
        ),
      ),
    );
  }

  void _showSnackbar(String text) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(text),
      duration: Duration(milliseconds: 1500),
    ));
  }
}
