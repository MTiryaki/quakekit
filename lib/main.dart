import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart'
    as permhand; //TODO confirm setup on ios
import 'package:google_maps_flutter/google_maps_flutter.dart'; //TODO setup
import 'package:http/http.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart'; //TODO set the fuck up

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(InitBuild());
}

class InitBuild extends StatelessWidget {
  final Future<FirebaseApp> _init = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _init,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return QuakeApp(-1);
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return QuakeApp(1);
        }
        return QuakeApp(0);
      },
    );
  }
}

// ignore: must_be_immutable
class QuakeApp extends StatelessWidget {
  var authStatus = 0;
  QuakeApp(this.authStatus);
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
  //TODO replace placeholder
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
                    MaterialPageRoute(
                        builder: (context) => PageLocServices(null, null)),
                  );
                }),
          ],
        ),
      ),
    );
  }
}

class PageLocServices extends StatefulWidget {
  const PageLocServices(this._loc, this._locbg);
  final permhand.Permission _loc;
  final permhand.Permission _locbg;
  @override
  _PageLocServicesState createState() => _PageLocServicesState(_loc, _locbg);
}

class _PageLocServicesState extends State<PageLocServices> {
  _PageLocServicesState(this._loc, this._locbg); //TODO what the fuck is this
  final permhand.Permission _loc;
  final permhand.Permission _locbg;
  permhand.PermissionStatus _locStat = permhand.PermissionStatus.undetermined;
  permhand.PermissionStatus _locbgStat = permhand.PermissionStatus.undetermined;
  @override
  void initState() {
    super.initState();
    _locPerm();
    testPerm();
    getPerm();
    testPerm();
  }

  void testPerm() async {
    print(_locStat.toString());
    print(_locbgStat.toString());
  }

  void _locPerm() async {
    final statusLoc = await _loc.status;
    final statusLocbg = await _locbg.status;
    setState(() {
      _locStat = statusLoc;
      _locbgStat = statusLocbg;
    });
  }

  Future<void> getPerm() async {
    final statusLoc = await _loc.request();
    final statusLocbg = await _locbg.request();
    setState(() {
      _locStat = statusLoc;
      _locbgStat = statusLocbg;
    });
  }

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
              '',
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
                  MaterialPageRoute(builder: (context) => PageContactsPerm()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PageContactsPerm extends StatefulWidget {
  @override
  _PageContactsPermState createState() => _PageContactsPermState();
}

class _PageContactsPermState extends State<PageContactsPerm> {
  @override //TODO contacts permission state
  void initState() {
    super.initState();
    //_contactPerm();
  }

  void _contactPerm() {
    //fuck.
  }

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
  bool check;
  var _number;
  @override
  void initState() {
    check = false;
    super.initState();
  }

  void _confirmCheck(bool val) {
    setState(() {
      if (!check)
        check = true;
      else
        check = false;
    });
  }

  void _authRequest(String _phoneNum) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: _phoneNum,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int resendToken) {},
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

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
                      FilteringTextInputFormatter.allow(RegExp("[+0123456789]"))
                    ],
                    maxLines: 1,
                    maxLength: 14,
                    keyboardType: TextInputType.phone,
                    autocorrect: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Phone Number',
                    ),
                    onChanged: (String newVal) {
                      _number = newVal;
                    })),
            Container(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Checkbox(value: check, onChanged: _confirmCheck),
              Text("I have read and agreed on blablabla"),
            ])),
            ElevatedButton(
              onPressed: () {
                if (check) {
                  _authRequest(_number);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PagePhoneConfirm()));
                }
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
  //TODO plug in firebase for auth purposes
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
              child: Text("Confirm"),
            ),
          ],
        ),
      ),
    );
  }
}

class PageAddressData extends StatefulWidget {
  @override
  _PageAddressDataState createState() => _PageAddressDataState();
}

String cityName = null;
void _test() {}

class _PageAddressDataState extends State<PageAddressData> {
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
                items: <String>[
                  //watame wa warukunai yo ne
                  'Adana',
                  'Adıyaman',
                  'Afyon',
                  'Ağrı',
                  'Amasya',
                  'Ankara',
                  'Antalya',
                  'Artvin',
                  'Aydın',
                  'Balıkesir',
                  'Bilecik',
                  'Bingöl',
                  'Bitlis',
                  'Bolu',
                  'Burdur',
                  'Bursa',
                  'Çanakkale',
                  'Çankırı',
                  'Çorum',
                  'Denizli',
                  'Diyarbakır',
                  'Edirne',
                  'Elazığ',
                  'Erzincan',
                  'Erzurum',
                  'Eskişehir',
                  'Gaziantep',
                  'Giresun',
                  'Gümüşhane',
                  'Hakkari',
                  'Hatay',
                  'Isparta',
                  'İçel (Mersin)',
                  'İstanbul',
                  'İzmir',
                  'Kars',
                  'Kastamonu',
                  'Kayseri',
                  'Kırklareli',
                  'Kırşehir',
                  'Kocaeli',
                  'Konya',
                  'Kütahya',
                  'Malatya',
                  'Manisa',
                  'K.maraş',
                  'Mardin',
                  'Muğla',
                  'Muş',
                  'Nevşehir',
                  'Niğde',
                  'Ordu',
                  'Rize',
                  'Sakarya',
                  'Samsun',
                  'Siirt',
                  'Sinop',
                  'Sivas',
                  'Tekirdağ',
                  'Tokat',
                  'Trabzon',
                  'Tunceli',
                  'Şanlıurfa',
                  'Uşak',
                  'Van',
                  'Yozgat',
                  'Zonguldak',
                  'Aksaray',
                  'Bayburt',
                  'Karaman',
                  'Kırıkkale',
                  'Batman',
                  'Şırnak',
                  'Bartın',
                  'Ardahan',
                  'Iğdır',
                  'Yalova',
                  'Karabük',
                  'Kilis',
                  'Osmaniye',
                  'Düzce'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'il',
                ),
                onChanged: (String newValue) {
                  cityName = newValue;
                }),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.5),
              child: DropdownButtonFormField(
                  items: null,
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
                child: Text("Confirm")),
          ],
        ),
      ))),
    );
  }
}

class PageEmergencyContacts extends StatelessWidget {
  //TODO actually implement this ffs
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
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PageSecure()));
                },
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
                    Navigator.pushNamed(context, 'assistRoute');
                  },
                  child: Text("Assistant")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'latestRoute');
                  },
                  child: Text("Latest")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'mapRoute');
                  },
                  child: Text("Map")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'profileRoute');
                  },
                  child: Text("Profile"))
            ],
          ),
        ),
      ),
    );
  }
}

class PageSecure extends StatefulWidget {
  @override
  _PageSecureState createState() => _PageSecureState();
}

class _PageSecureState extends State<PageSecure> {
  void initState() {
    super.initState();
    //TODO send current location and current status
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('This is an example.'),
      ),
    );
  }
}

class PageInsecure extends StatefulWidget {
  @override
  _PageInsecureState createState() => _PageInsecureState();
}

class _PageInsecureState extends State<PageInsecure> {
  void initState() {
    super.initState();
    //TODO send current location and current status
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('This is an example.'),
      ),
    );
  }
}

class PageProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              //TODO: fix
              children: [
                // Text(
                //   "profil",
                //   style: Theme.of(context).textTheme.headline4,
                // ),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text("Name Here"),
                        subtitle: Text("æææ"),
                      ),
                    ],
                  ),
                ),
                Text(
                  "Emergency Contacts",
                  style: Theme.of(context).textTheme.headline4,
                ),
                Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("a"),
                      Text("aeae")
                    ], //TODO: feed data from emergency contacts
                  ),
                )
              ],
            ),
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
                      Navigator.pushNamed(context, 'mapRoute');
                    },
                    child: Text("map??")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, 'profileRoute');
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
                      Navigator.pushNamed(context, 'mapRoute');
                    },
                    child: Text("map??")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, 'profileRoute');
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
                    Text("Magnitude:${items[index]}")
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
                  "text goes here",
                  textAlign: TextAlign.center,
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PagePreQuake()));
                  },
                  child: Text("Before an Earthquake")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PageInQuake()));
                  },
                  child: Text("During an Earthquake")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PagePostQuake()));
                  },
                  child: Text("After an Earthquake")),
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
                      Navigator.pushNamed(context, 'latestRoute');
                    },
                    child: Text("latest")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, 'mapRoute');
                    },
                    child: Text("map??")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, 'profileRoute');
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
