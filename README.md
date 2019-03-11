# Yo! In Flutter.

![yo_flutter](https://user-images.githubusercontent.com/11478053/49794374-b1a1ce00-fd37-11e8-9364-9ec0efde9ca6.png)

Basically Yo! written in Flutter. Done in a three hour workshop with people who never used Flutter before 🍻

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
For now, you can use the following data:
```dart
final List<Person> friends = [
  Person("aaaa", "Frederik Schweiger", "https://lh3.googleusercontent.com/HJalMgJTCQ_Tf3OJrYLrUEYDuY2hQ6vw16Nw9RexsoQyJtl3TaduDICztFsV3-OeGTQqnlOIZlwk9q0=s360-rw-no"),
  Person("bbbb", "Pascal Welsch", "https://lh3.googleusercontent.com/GtJbCj84PLL8BLTORq_9MDxTR-UUFxwjY7h9dQRZcRrhxQlizifGWE9fZf6hVtlHcx3YSATWhA7qO8M=s360-rw-no"),
  Person("cccc", "Georg Bednorz", "https://lh3.googleusercontent.com/s4jjTjRsseMEaHhGUYLehPvatrs5h-DDUI7TcJh5RZYUCk73Ggh60IGEXYcxhW795IikC-LN3E9y-1o=s360-rw-no"),
  Person("dddd", "Seth Ladd", "https://pbs.twimg.com/profile_images/986316447293952000/oZWVUWDs_400x400.jpg"),
  Person("eeee", "Tim Sneath", "https://pbs.twimg.com/profile_images/653618067084218368/XlQA-oRl_400x400.jpg"),
];
```

## Lesson 3

Build the login screen with [scoped_model](https://github.com/brianegan/scoped_model/)


## Lesson 4

Setup firebase

- Create Android and iOS apps.
- Enable Google Authentication
- Deploy firebase functions

## Lesson 5

Show real users form firebase

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
