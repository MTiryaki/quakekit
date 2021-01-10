import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as permhand;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';
import 'package:json_annotation/json_annotation.dart';
import 'models/UserModel.dart';

part 'main.g.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) => runApp(QuakeApp()));
}

Future<List<UserModel>> apiCall() async {
  http.Response response =
      await http.get("https://quakekit-api.hbksoftware.com.tr/api/User");
  List responseJson = json.decode(response.body);
  return responseJson.map((m) => new UserModel.fromJson(m)).toList();
}

class QuakeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
      home: PageWelcome(null,null),
    );
  }
}

class PageWelcome extends StatefulWidget {
  const PageWelcome(this._loc, this._locbg);
  final permhand.Permission _loc, _locbg;
  @override
  _PageWelcomeState createState() => _PageWelcomeState(_loc, _locbg);
}

class _PageWelcomeState extends State<PageWelcome> {
  _PageWelcomeState(this._loc, this._locbg);
  final permhand.Permission _loc, _locbg;
  permhand.PermissionStatus _locStat;
  permhand.PermissionStatus _locbgStat;

  PageController pageController;
  String infoButton = "Continue";
  List<String> texts;
  int pageindex;
  @override
  void initState() {
    super.initState();
    _locStat = permhand.PermissionStatus.undetermined;
    _locbgStat = permhand.PermissionStatus.undetermined;
    _locPerm();
    testPerm();
    getPerm();
    testPerm();
    pageindex = 0;
    pageController = PageController(initialPage: pageindex);
    texts = [
      "Welcome",
      "Good morning, and welcome to the Black Mesa Transit System. This automated train is provided for the comfort and convenience of Black Mesa Research Facility personnel.",
      "Service Permission",
      "Contacts Permission"
    ];
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

  void _contactPerm() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: PageView.builder(
            itemCount: 3,
            controller: pageController,
            onPageChanged: (index){
              setState(() {
                pageindex = index;
                if(pageindex < 2){
                  infoButton = "Continue ";
                }else{
                  infoButton = "Next Page";
                }
              });
              debugPrint("Değişti");
            },
            itemBuilder: (context, index){
              return Container(
                padding: EdgeInsets.only(
                    left: 11,
                    right: 11
                ),
                width: double.infinity,
                height: double.infinity,
                color: Colors.deepOrange,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                    Expanded(
                        child: Material(
                          borderRadius: BorderRadius.circular(60),
                          elevation: 12,
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 8,
                                right: 8
                            ),
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(60)
                            ),
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.bottomCenter,
                                    width: double.infinity,
                                    height: double.infinity,
                                    child: Text(turnText(index), style: Theme.of(context).textTheme.headline4, textAlign: TextAlign.center,),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: double.infinity,
                                    height: double.infinity,
                                    child: Text(texts[1], textAlign: TextAlign.center),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.topCenter,
                                    //color: Colors.white,
                                    width: double.infinity,
                                    height: double.infinity,
                                    child: InkWell(
                                      onTap: (){
                                        setState(() {
                                          if(pageindex < 2){
                                            pageindex++;
                                            pageController.jumpToPage(pageindex);
                                            pageindex == 1 ? infoButton = "Continue" : infoButton = "Next Page";
                                          }else{
                                            Navigator.push(context,MaterialPageRoute(builder: (context) => PagePhoneHom()));
                                          }
                                        });
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                  begin: Alignment.centerLeft,
                                                  end: Alignment.centerRight,
                                                  colors: [
                                                    Colors.teal[300],
                                                    Colors.teal[400],
                                                    Colors.teal[500],
                                                  ]
                                              ),
                                              borderRadius: BorderRadius.circular(30),
                                              border: Border.all(
                                                  color: Colors.blue,
                                                  width: 3
                                              ),
                                              color: Colors.teal
                                          ),
                                          child: Center(child: Text(infoButton,style: TextStyle(fontSize: 24),),)
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  ],
                ),
              );
            })
    );
  }
  String turnText(int index){
    if(index == 0){
      return texts[0];
    }
    else if(index == 1){
      return texts[2];
    }
    else{
      return texts[3];
    }
  }
}

class PagePhoneHom extends StatefulWidget {
  @override
  _PagePhoneHomState createState() => _PagePhoneHomState();
}

class _PagePhoneHomState extends State<PagePhoneHom> {
  final _scKey = GlobalKey<ScaffoldState>();
  bool check;
  TextEditingController pNumCont;
  TextEditingController vCodeCont;
  FirebaseAuth _fAuth = FirebaseAuth.instance;
  String _vId;
  String _num;
  @override
  void initState() {
    super.initState();
    check = false;
    vCodeCont = TextEditingController(text: "123456");
    pNumCont = TextEditingController(text: "+905354992959");
  }

  void _confirmCheck(bool val) {
    setState(() {
      if (!check)
        check = true;
      else
        check = false;
    });
  }

  void sendCode() async {
    await _fAuth.verifyPhoneNumber(
        phoneNumber: _num,
        timeout: Duration(seconds: 20),
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
          await _fAuth.signInWithCredential(phoneAuthCredential);
        },
        verificationFailed: (FirebaseAuthException authException) {
          _scKey.currentState
              .showSnackBar(SnackBar(content: Text("Uh oh. $authException")));
        },
        codeSent: (String verificationId, [int forceResendingToken]) async {
          _vId = verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _vId = verificationId;
        });
  }

  Future<bool> confirmCode() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _vId,
        smsCode: vCodeCont.text,
      );
      await _fAuth.signInWithCredential(credential);
      return true;
    } catch (e) {
      _scKey.currentState.showSnackBar(SnackBar(content: Text("Uh oh. $e")));
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scKey,
        body: Container(
          color: Colors.blue,
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.red,
                  child: RaisedButton(
                      child: Text("asdas"),
                      onPressed: (){
                        Navigator.push(context,MaterialPageRoute(builder: (context) => PageAddressData()));
                      }),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.only(
                      left: 10,
                      right: 10
                  ),
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.yellow,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextField(
                        maxLength: 13,
                        maxLines: 1,
                        controller: pNumCont,
                        keyboardType: TextInputType.phone,
                        autocorrect: false,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Phone Number",
                            hintText: "+90xxxxxxxxxx"
                        ),
                        onChanged: (value){

                        },
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        )
    );
  }
}

class PageAddressData extends StatefulWidget {
  @override
  _PageAddressDataState createState() => _PageAddressDataState();
}

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
              child: Text("Address Data"),
            ),
            DropdownButtonFormField(
                items: <String>[
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
                  labelText: 'City',
                ),
                onChanged: (String newValue) {}),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'District',
              ),
            ),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Neighborhood',
              ),
            ),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Building',
              ),
            ),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Floor',
              ),
            ),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Condo',
              ),
            ),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Address Description',
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  //TODO insert API PUT/POST here
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

class PageEmergencyContacts extends StatefulWidget {
  @override
  _PageEmergencyContactsState createState() => _PageEmergencyContactsState();
}

List<Contact> emergencyContacts = new List<Contact>();

class _PageEmergencyContactsState extends State<PageEmergencyContacts> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _pickContact() async {
    try {
      final Contact contact = await ContactsService.openDeviceContactPicker(
          iOSLocalizedLabels: false);
      setState(() {
        emergencyContacts.add(contact);
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Emergency Contacts',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              'Good morning, and welcome to the Black Mesa Transit System.',
              textAlign: TextAlign.center,
            ),
            RaisedButton(
              child: const Text('Pick a contact'),
              onPressed: _pickContact,
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
              child: Text("Secure"),
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
                child: Text("Insecure"))
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
                        leading: Icon(Icons.portrait),
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
                    children: [Text("a"), Text("aeae")],
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
                    child: Text("Assistant")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, 'latestRoute');
                    },
                    child: Text("Latest")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, 'mapRoute');
                    },
                    child: Text("Map")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, 'profileRoute');
                    },
                    child: Text("Profile"))
              ],
            ),
          ),
        ));
  }
}

class PageNewProfile extends StatefulWidget {
  @override
  _PageNewProfileState createState() => _PageNewProfileState();
}

class _PageNewProfileState extends State<PageNewProfile> {
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
              child: Text("Address Data"),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.5),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'District',
                ),
              ),
            ),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Address Line 2',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.5),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Address Line 2',
                ),
              ),
            ),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Address Description',
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  //TODO insert API PUT/POST here
                },
                child: Text("Confirm")),
          ],
        ),
      ))),
    );
  }
}

class PageMap extends StatefulWidget {
  @override
  _PageMapState createState() => _PageMapState();
}

class _PageMapState extends State<PageMap> {
  Location location = new Location();
  bool _serviceEnabled;
  LocationData _locData;
  PermissionStatus _permissionGranted;
  @override
  void initState() {
    super.initState();
    initLoc();
  }

  void initLoc() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locData = await location.getLocation();
  }

  final Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(41.042169, 29.0070704),
                zoom: 17,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
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
                    child: Text("Assistant")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, 'latestRoute');
                    },
                    child: Text("Latest")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, 'mapRoute');
                    },
                    child: Text("Map")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, 'profileRoute');
                    },
                    child: Text("Profile"))
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

@JsonSerializable()
class Quake {
  final String locName, depth, sizes, lat, lng, date, time;
  Quake(
      {this.locName,
      this.depth,
      this.sizes,
      this.lat,
      this.lng,
      this.date,
      this.time});

  factory Quake.fromJson(Map<String, dynamic> json) => _$QuakeFromJson(json);

  Map<String, dynamic> toJson() => _$QuakeToJson(this);
}

class _PageLatestState extends State<PageLatest> {
  List<Quake> quakes;
  Future<List<Quake>> fetchQuake() async {
    final response = await http
        .get('https://quakekit-api.hbksoftware.com.tr/api/EarthQuake');

    if (response.statusCode == 200) {
      return compute(parseQuakes, response.body);
    } else {
      throw Exception('Failed to load');
    }
  }

  List<Quake> parseQuakes(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<Quake>((json) => Quake.fromJson(json)).toList();
  }

  @override
  void initState() {
    super.initState();
    fetchQuake().whenComplete(() => quakes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Latest Earthquakes"),
        ),
        body: FutureBuilder<List<UserModel>>(
          future: apiCall(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Container();
            List<UserModel> userModel = snapshot.data;
            return new ListView(
              children: userModel.map((user) => Text(user.uID)).toList(),
            );
          },
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
                    child: Text("Assistant")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, 'latestRoute');
                    },
                    child: Text("Latest")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => PageMap()));
                    },
                    child: Text("Map")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PageProfile()));
                    },
                    child: Text("Profile"))
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
                  "Earthquake Assistant",
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
                    child: Text("Assistant")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, 'latestRoute');
                    },
                    child: Text("Latest")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, 'mapRoute');
                    },
                    child: Text("Map")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, 'profileRoute');
                    },
                    child: Text("Profile"))
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
