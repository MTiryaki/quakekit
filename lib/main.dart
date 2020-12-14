import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(QuakeApp());
}

class QuakeApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuakeKit',
      theme: ThemeData(
        primarySwatch: Colors.red,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: WelcomePage(), //will be an issue. i can smell it.
    );
  }
}

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.add_comment,
            ),
            Text(
              'Welcome',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              'Good morning, and welcome to the Black Mesa Transit System. This automated train is provided for the comfort and convenience of Black Mesa Research Facility personnel.',
              textAlign: TextAlign.center,
            ),
            IconButton(
                icon: Icon(Icons.wysiwyg),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PageLocServices()),
                  );
                }),
          ],
        ),
      ),
      /*bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        shape: const CircularNotchedRectangle(),
        child: Container(
          height: 50.0,
        ),
      ), */ //BottomAppBar This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class PageLocServices extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.add_comment,
            ),
            Text(
              'Welcome, Part 2',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              'Good morning, and welcome to the Black Mesa Transit System. This automated train is provided for the comfort and convenience of Black Mesa Research Facility personnel.',
              textAlign: TextAlign.center,
            ),
            IconButton(
              icon: Icon(Icons.wysiwyg),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PageSomethingElse()),
                );
              },
            ),
          ],
        ),
      ),
      /*bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        shape: const CircularNotchedRectangle(),
        child: Container(
          height: 50.0,
        ),
      ), */ //BottomAppBar This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class PageSomethingElse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.add_comment,
            ),
            Text(
              'you did it',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              'Good morning, and welcome to the Black Mesa Transit System. This automated train is provided for the comfort and convenience of Black Mesa Research Facility personnel.',
              textAlign: TextAlign.center,
            ),
            IconButton(
              icon: Icon(Icons.wysiwyg),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PagePhoneHom()));
              },
            ),
          ],
        ),
      ),
      /*bottomNavigationBar: BottomAppBar(
                            color: Colors.blue,
                            shape: const CircularNotchedRectangle(),
                            child: Container(
                              height: 50.0,
                            ),
                          ), */ //BottomAppBar This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class PagePhoneHom extends StatefulWidget {
  @override
  _PagePhoneHomState createState() => _PagePhoneHomState();
}

class _PagePhoneHomState extends State<PagePhoneHom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextField(
                  // inputFormatters: [
                  //   FilteringTextInputFormatter.allow(
                  //       RegExp("[0123456789+]")) //TODO: reconsider regex?
                  // ],
                  maxLines: 1,
                  //maxLength: 20, //TODO: reconsider?
                  keyboardType: TextInputType.phone,
                  autocorrect: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Phone Number',
                  ),
                )),
            Container(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Checkbox(
                  value: false, onChanged: null), //TODO: validation of check
              Text("I have read and agreed on blablabla"),
            ])),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PagePhoneConfirm()));
              },
              child: Text("Send Confirmation Code"),
            ),
          ],
        ),
      ),
    );
  }
}

class PagePhoneConfirm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}