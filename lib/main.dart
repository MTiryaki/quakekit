import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(QuakeApp());
}

class QuakeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuakeKit',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        'assistRoute': (context) => PageAssistant(),
        'mapRoute': (context) => PageMap(),
        'mainRoute': (context) => PageMain(),
        'latestRoute': (context) => PageLatest(),
        'profileRoute': (context) => PageProfile(),
      },
      home: PageWelcome(),
    );
  }
}

class PageWelcome extends StatelessWidget {
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
    );
  }
}

class PagePhoneHom extends StatefulWidget {
  @override
  _PagePhoneHomState createState() => _PagePhoneHomState();
}

class _PagePhoneHomState extends State<PagePhoneHom> {
  bool check = false;
  /*void _validate(bool validate) {
    _setState(); or something idk
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextField(
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[0123456789]"))
                  ],
                  maxLines: 1,
                  maxLength: 11,
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
                  value: check, onChanged: null), //TODO: validation of check
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
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextField(
                  maxLines: 1,
                  autocorrect: false,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Confirmation Code',
                  ),
                )),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PageAddressData()));
              },
              child: Text("Send Confirmation Code"),
            ),
          ],
        ),
      ),
    );
  }
}

class PageAddressData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Form(
              child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text("format this or you are have the big gae"),
            ),
            DropdownButtonFormField(
                items: null, //insert list of thing cities
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'il',
                ),
                onChanged: null),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.5),
              child: DropdownButtonFormField(
                  items: null, //insert list of thing cities
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'ilçe',
                  ),
                  onChanged: null),
            ),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'açık adres',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.5),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'açık adres pt2',
                ),
              ),
            ),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'adres tarifi',
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PageEmergencyContacts()));
                },
                child: Text("yællah")),
          ],
        ),
      ))),
    );
  }
}

class PageEmergencyContacts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'fuck this',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              'Good morning, and welcome to the Black Mesa Transit System.',
              textAlign: TextAlign.center,
            ),
            IconButton(
              icon: Icon(Icons.wysiwyg),
              onPressed: () {
                Navigator.pushNamed(context, 'mainRoute');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PageMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MaterialButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PageSecure()));
              },
              elevation: 2.0,
              disabledColor: Colors.blue,
              padding: EdgeInsets.all(15.0),
              shape: CircleBorder(),
              child: Text("secure"),
            ),
            MaterialButton(
                onPressed: null,
                elevation: 2.0,
                disabledColor: Colors.blue,
                padding: EdgeInsets.all(15.0),
                shape: CircleBorder(),
                child: Text("insecure"))
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        shape: const CircularNotchedRectangle(),
        child: Container(
          height: 50.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PageAssistant()));
                  },
                  child: Text("assistant")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PageLatest()));
                  },
                  child: Text("latest")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PageMap()));
                  },
                  child: Text("map??")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PageProfile()));
                  },
                  child: Text("profile"))
            ],
          ),
        ),
      ),
    );
  }
}

class PageSecure extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class PageInsecure extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class PageProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //TODO: fix
            children: [
              Text("profil"),
              //some sort of card
              Text("Emergency Contacts"),
              //emergency contacts
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.blue,
          shape: const CircularNotchedRectangle(),
          child: Container(
            height: 50.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, 'assistRoute');
                    },
                    child: Text("ass-istant")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PageLatest()));
                    },
                    child: Text("latest")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => PageMap()));
                    },
                    child: Text("map??")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PageProfile()));
                    },
                    child: Text("profile"))
              ],
            ),
          ),
        ));
  }
}

class PageMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(/* TODO: map. seriously. */),
        bottomNavigationBar: BottomAppBar(
          color: Colors.blue,
          shape: const CircularNotchedRectangle(),
          child: Container(
            height: 50.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PageAssistant()));
                    },
                    child: Text("ass-istant")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PageLatest()));
                    },
                    child: Text("latest")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => PageMap()));
                    },
                    child: Text("map??")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PageProfile()));
                    },
                    child: Text("profile"))
              ],
            ),
          ),
        ));
  }
}

class PageLatest extends StatefulWidget {
  @override
  _PageLatestState createState() => _PageLatestState();
}

class _PageLatestState extends State<PageLatest> {
  List<String> items =
      List<String>.generate(10000, (i) => "Item $i"); //temporary
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Latest Earthquakes"),
        ),
        body: Center(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("${items[index]}"),
                    Text("magnitude:${items[index]}")
                  ],
                ),
              );
            },
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.blue,
          shape: const CircularNotchedRectangle(),
          child: Container(
            height: 50.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, 'assistRoute');
                    },
                    child: Text("ass-istant")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, 'latestRoute');
                    },
                    child: Text("latest")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => PageMap()));
                    },
                    child: Text("map??")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PageProfile()));
                    },
                    child: Text("profile"))
              ],
            ),
          ),
        ));
  }
}

class PageAssistant extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                //TODO: figure out how to make this not look bad
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                    "text goes herehttps://i.redd.it/cqrweo9xcvv41.pnghttps://i.redd.it/cqrweo9xcvv41.pnghttps://i.redd.it/cqrweo9xcvv41.pnghttps://i.redd.it/cqrweo9xcvv41.pnghttps://i.redd.it/cqrweo9xcvv41.png"),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PagePreQuake()));
                  },
                  child: Text("test")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PageInQuake()));
                  },
                  child: Text("test")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PagePostQuake()));
                  },
                  child: Text("test")),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.blue,
          shape: const CircularNotchedRectangle(),
          child: Container(
            height: 50.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PageAssistant()));
                    },
                    child: Text("ass-istant")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PageLatest()));
                    },
                    child: Text("latest")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => PageMap()));
                    },
                    child: Text("map??")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PageProfile()));
                    },
                    child: Text("profile"))
              ],
            ),
          ),
        ));
  }
}

class PagePostQuake extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(),
    );
  }
}

class PageInQuake extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(),
    );
  }
}

class PagePreQuake extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(),
    );
  }
}
