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

You've finished this lessen if you see 

## Lesson 2

Create the list layout of your friends. Use the screenshot above as reference.

1. Create a `FriendsPage` widget. "Screen" are called "Pages" in Flutter.
2. Use the [`ListView.builder`](https://docs.flutter.io/flutter/widgets/ListView-class.html) widget to show the items. 

Here are some helpful snippets:
```dart
final List<Person> friends = [
  Person("aaaa", "Frederik Schweiger", "https://lh3.googleusercontent.com/HJalMgJTCQ_Tf3OJrYLrUEYDuY2hQ6vw16Nw9RexsoQyJtl3TaduDICztFsV3-OeGTQqnlOIZlwk9q0=s360-rw-no"),
  Person("bbbb", "Pascal Welsch", "https://lh3.googleusercontent.com/GtJbCj84PLL8BLTORq_9MDxTR-UUFxwjY7h9dQRZcRrhxQlizifGWE9fZf6hVtlHcx3YSATWhA7qO8M=s360-rw-no"),
  Person("cccc", "Georg Bednorz", "https://lh3.googleusercontent.com/s4jjTjRsseMEaHhGUYLehPvatrs5h-DDUI7TcJh5RZYUCk73Ggh60IGEXYcxhW795IikC-LN3E9y-1o=s360-rw-no"),
  Person("dddd", "Seth Ladd", "https://pbs.twimg.com/profile_images/986316447293952000/oZWVUWDs_400x400.jpg"),
  Person("eeee", "Tim Sneath", "https://pbs.twimg.com/profile_images/653618067084218368/XlQA-oRl_400x400.jpg"),
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

Use the existing `SessionModel` and register it globally in your `main` function.
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
- Create the iOS apps with `school.flutter.yo` as bundleId
- Enable Google Authentication (`Develop -> Authentication -> Sign-in method -> Goolge -> Enable`) 
- Deploy firebase cloud functions, see `fireabse/README.md`

## Lesson 5

Show real users form firebase

1. Refactor your static `FriendsPage` and load your Friends from firebase.
```dart
final stream = Firestore.instance.collection(Person.REF).orderBy("name").snapshots();
stream.listen((QuerySnapshot snapshot) {
  final friends = snapshot.documents.map((data) => Person.fromJson(data.data));
});
```

## Lesson 6

Send push notifications

Caution: 
- You won't see a notification if the app is in foreground
- Test on a real device, not the emulator/simulator
- 


## How to build the app

> Are you in a hurry and just want to check out the end-result on your phone? In the [releases tab](https://github.com/flschweiger/yo-flutter/releases/tag/1.0) you will find a precompiled APK to download 🚀

If you would like to compile the code and run the app on your machine, you will have to create a new Firebase project and make sure to add the following files:

1. Create a new firebase project https://console.firebase.google.com
2. Register the ios and android application 
   
On Android, register the SHA-1 of your local certificate to Firebase to make Google Sign-In work.
> `keytool -exportcert -list -v \
-alias androiddebugkey -keystore ~/.android/debug.keystore`

and download the firebase configuration files to
- `ios/Runner/GoogleService-Info.plist`
- `android/app/google-services.json`  

3. Setup Firebase Authentication: Go to `Develop -> Authentication` and set up sign-in method  

On iOS you need to edit `ios/Runner/Info.plist` and paste in your `REVERSED_CLIENT_ID`.

Last but not least you will have to deploy the Cloud Function inside the `firebase` folder and replace the URL inside the `home_page.dart` file. And voilà, you are all set!

## Disclaimer

Please note that this code is not production ready, it should just show how quick you could build a million dollar app for Android and iOS 😉
