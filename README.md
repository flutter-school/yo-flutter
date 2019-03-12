# Yo! In Flutter.

![yo_flutter](https://user-images.githubusercontent.com/11478053/49794374-b1a1ce00-fd37-11e8-9364-9ec0efde9ca6.png)

Basically [Yo!](http://www.justyo.co/) written in Flutter. Done in a three hour workshop with people who never used Flutter before 🍻

## Lesson 1

- Clone the project `git clone git@github.com:flutter-school/yo-flutter.git` and 
- run it `flutter run`

Flutter install instructions: 
- https://flutter.dev/docs/get-started/install
- https://flutter.dev/docs/get-started/editor

If you have trouble setting up flutter, ask for support

You've finished this lessen if you see the congratulations screen on your phone.

## Lesson 2

Create the list layout of your friends. Use the screenshot above as reference.

1. Create a `FriendsPage` widget. "Screen" are called "Pages" in Flutter.
2. Use the [`ListView.builder`](https://docs.flutter.io/flutter/widgets/ListView-class.html) widget to show the items. 

Use the existing `Person` data class in `person.dart`.

Here are some helpful snippets:
```dart
final List<Person> friends = [
    Person("ffff", "Frederik Schweiger", "https://pbs.twimg.com/profile_images/1074391975820972033/SP7txc1D_400x400.jpg"),
    Person("pppp", "Pascal Welsch", "https://pbs.twimg.com/profile_images/941273826557677568/wCBwklPP_400x400.jpg"),
    Person("gggg", "Georg Bednorz", "https://pbs.twimg.com/profile_images/1091439933716381701/PIfcpdHq_400x400.png"),
    Person("ssss", "Seth Ladd", "https://pbs.twimg.com/profile_images/986316447293952000/oZWVUWDs_400x400.jpg"),
    Person("kkkk", "Kate Lovett", "https://pbs.twimg.com/profile_images/1048927764156432384/JxEqQ9dX_400x400.jpg"),
    Person("tttt", "Tim Sneath", "https://pbs.twimg.com/profile_images/653618067084218368/XlQA-oRl_400x400.jpg"),
    Person("hhhh", "Filip Hráček", "https://pbs.twimg.com/profile_images/796079953079111680/ymD9DY5g_400x400.jpg"),
    Person("aaaa", "Andrew Brogdon", "https://pbs.twimg.com/profile_images/651444930884186112/9vlhNFlu_400x400.png"),
    Person("nnnn", "Nitya Narasimhan", "https://pbs.twimg.com/profile_images/988808912504733697/z03gHVFL_400x400.jpg"),
];

List<Color> _colors = [
    Color(0xFFF8B195),
    Color(0xFFF67280),
    Color(0xFFC06C84),
    Color(0xFF6C5B7B),
    Color(0xFF355C7D),
    Color(0xFF34495D),
];
```

## Lesson 3

<img height="400px" src="https://user-images.githubusercontent.com/1096485/54165147-c2a9ca80-445f-11e9-8e9e-c1956e17c9ed.png" ></img>

Build the login screen with [scoped_model](https://github.com/brianegan/scoped_model/)

Use the existing `SessionModel` in `session_model.dart` and register it globally in your `main` function.

```dart
final SessionModel sessionModel = SessionModel();
runApp(ScopedModel<SessionModel>(
  model: sessionModel,
  child: YoApp(),
  ));
```

Build a Widget which toggles between the `FriedsPage` and a `LoginPage` depending on the session state.
Use `ScopedModelDescendant` to access the `SessionModel`

```dart
ScopedModelDescendant<SessionModel>(
    builder: (BuildContext context, Widget child, SessionModel model) {
      // TODO use model
      return anyWidget;
    },
),
```

Lear how ScopedModel works under the hood: [InheritedWidgets and App-scope/Page-scope](https://medium.com/@mehmetf_71205/inheriting-widgets-b7ac56dbbeb1)

## Lesson 4 (optional)

We want to send YO!s to each other via push notifications. 
You need a apple developer account to make it work with iOS.
For now, we'll focus on Android to receive the notifications.

The android project is already fully connected to a instance firebase. 
If you want full access you have to create your own firebase project.

- Create the Android app
    - applicationId `school.flutter.yo`
    - SHA-1 `D2:6E:E8:94:62:5E:1D:74:C7:84:26:0A:32:8A:4E:26:2D:DD:FE:E4` (for existing key `flutterschool.jks`)
- (Create the iOS apps with `school.flutter.yo` as bundleId)


- Download the firebase configuration files to
    - `android/app/google-services.json` 
    - `ios/Runner/GoogleService-Info.plist`
    On iOS you need to edit `ios/Runner/Info.plist` and paste in your `REVERSED_CLIENT_ID`.

- Enable Google Authentication (`Develop -> Authentication -> Sign-in method -> Goolge -> Enable`) 



- Deploy firebase cloud functions, see `fireabse/README.md`

## Lesson 5

Show real users form firebase

1. Refactor your static `FriendsPage` and load your Friends from firebase. 
Don't put the Firebase loading code in the UI, create a page-scoped model (`FriendsModel`). 

Here's some code for you to start
```dart
class FriendsModel extends Model {
  /// Easy access to this model using [ScopedModel.of]
  static FriendsModel of(BuildContext context) =>
      ScopedModel.of<FriendsModel>(context);

  FriendsModel(this.userModel) {
    _loadFriends();
  }

  List<Person> get friends => _friends?.toList() ?? [];
  Iterable<Person> _friends;

  bool get isLoading => _friends == null;

  SessionModel userModel;

  Future<void> sendYo(Person person) async {
    // TODO
    throw "not implemented";
  }

  Future<void> _loadFriends() async {
    // TODO
    throw "not implemented";
  }
}
```

Now implement the data loading. 
This is how you get your friends form firebase.
(Don't forget to notify the UI after loading)
```dart
import 'package:cloud_firestore/cloud_firestore.dart';

final stream = Firestore.instance.collection(Person.REF).orderBy("name").snapshots();
stream.listen((QuerySnapshot snapshot) {
  final friends = snapshot.documents.map((data) => Person.fromJson(data.data));
});
```

## Lesson 6

Send push notifications

Register for firebase notifications after successful login
```dart
import 'package:firebase_messaging/firebase_messaging.dart';

final fmToken = await FirebaseMessaging().getToken();
Firestore.instance
    .collection("tokens")
    .document(_user.uid)
    .setData({'token': fmToken})
```

Tip: `print` a message with the users email address after successfully writing the token to firebase. 

## Lesson 7

Send yo! to another user

Implement `FriendsModel.sendYo` and call the firebase cloud function to notify other users that you think about them
```dart
await http.get('https://us-central1-yo-flutter-80f0f.cloudfunctions.net/sendYo?'
    'fromUid=${userModel.uid}&toUid=${person.uid}');
```

Caution: 
- You won't see a notification if the app is in foreground
- Test on a real device, not the emulator/simulator
- It doesn't work on iOS unless you've registered you APNs Authentication Key


## Bonus 1

Add a logout button to your app. 
Call `ScopedModel.of<SessionModel>(context).logout();` instead of creating a `ScopedModelDescendant`.

## Bonus 2

Rewrite the `FriendsModel` using immutable collections from [kt.dart](https://github.com/passsy/kt.dart)

## Disclaimer

Please note that this code is not production ready, it should just show how quick you could build a million dollar app for Android and iOS 😉


## Finished app

If you run into trouble we have a working example for you. Run

```bash
flutter run lib/finished/finished.dart
```

## License

```
Copyright 2019 flutter.school

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```