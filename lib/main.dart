import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as permhand;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';
import 'package:json_annotation/json_annotation.dart';
import 'models/EarthQuakeModel.dart';
import 'models/UserModel.dart';
import 'models/MeetingAreaModel.dart';

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
        fontFamily: "Raleway",
        primarySwatch: Colors.blue,
        textTheme: TextTheme(headline4: TextStyle(color: Colors.green), headline6: TextStyle(color: Colors.grey[600]), headline3: TextStyle(color: Colors.red)),
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
      body: Container(
        width: double.infinity,
        height: double.infinity,      
        child: Row(
          children: <Widget>[
            Expanded(
            child: Container(
              width: double.infinity,
              height: double.infinity,           
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(
              width: double.infinity,
              height: double.infinity,        
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,                   
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      height: double.infinity,                    
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> PageInsecure()));
                        },
                        child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.red,
                        ),
                        child: Center(child: Text("Güvende Değilim!", style: TextStyle(fontSize: 30))),
                      ),
                      )
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      height: double.infinity,                     
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> PageSecure()));
                        },
                        child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.green,
                        ),
                        child: Center(child: Text("Güvendeyim", style: TextStyle(fontSize: 30),)),
                      ),
                      )
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,                  
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              height: double.infinity,         
            ),
          ),
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
      body: Container(
        padding: EdgeInsets.only(
          left: 10,
          right: 10
        ),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text("YOUR LOCATION AND HEALTH STATUS HAS BEEN DELIVERED TO YOUR EMERGENCY PEOPLE.", textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline4),
            Container(
              child: Column(
                children: <Widget>[
                  Text("Warning !", textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline6),
                  SizedBox(height: 15,),
                  Text("After the shake has passed, electricity, gas and water valves should be closed, stoves and heaters should be turned off. By taking other security measures, the necessary goods and materials should be taken and the building should be left from the previously determined road and go to the assembly area."
                  ,textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline6,),
                ],
              ),
            )
          ],
        ),
      )
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
      body: Container(
        padding: EdgeInsets.only(
          left: 10,
          right: 10
        ),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text("YOUR LOCATION DATA HAS BEEN TRANSMITTED TO OFFICIALS AND EMERGENCY CONTACTS.", textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline3),
            Container(
              child: Column(
                children: <Widget>[
                  Text("Warning !", textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline6),
                  SizedBox(height: 15,),
                  Text("Do not panic. Stay away from unsecured objects such as shelves and windows. If possible, seek shelter by crouching next to a secure object and creating a triangle of life."
                  ,textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline6,),
                ],
              ),
            ),
            CircleAvatar(
              backgroundColor: Colors.grey,            
              maxRadius: 40,
              minRadius: 25,         
              child: Text("S.O.S", style: TextStyle(color: Colors.white,)),
            )
          ],
        ),
      )
    );
  }
}

class PageProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Container(
      width: double.infinity,
      height: double.infinity,
      //color: Colors.teal,
      child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                //color: Colors.brown,

                child: Stack(
                  children: <Widget>[                   
                    Column( /// Column ı kullanmamın sebebi 2 parcaya ayırmak bu şekilde dinamik hale getirmek cunku 
                    /// sadece Stack in içinde olunca Expanded bir işe yaramadı
                      children: <Widget>[
                      Expanded(/// arkaplandaki turuncu
                        flex: 3,
                        child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        padding: EdgeInsets.only(
                          left: 15,
                          right: 15,
                          bottom: 15
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                        ),
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(30),
                              bottomLeft: Radius.circular(30)
                            ),
                          ),
                        ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                        //color: Colors.yellow,
                        width: double.infinity,
                        height: double.infinity,
                        ),
                        )
                      ),
                      ],
                    ),
                    Align( /// yuvarlak resim
                      alignment: Alignment.bottomCenter,
                      child: CircleAvatar(
                      radius: 64,
                      backgroundColor: Colors.orange,
                        child: CircleAvatar(
                        radius: 55,
                        backgroundImage: AssetImage('assets/images/hbk.jpg'),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                //color: Colors.grey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("HASAN BATUHAN KURT", style: TextStyle(fontFamily: "Ralewayto",fontSize: 22),),
                    Text("Yazılım Mühendisi", style: TextStyle(fontSize: 16),)
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Container(
                margin: EdgeInsets.only(
                  left: 10,
                  right: 10
                ),
                padding: EdgeInsets.only(
                  top: 15,
                  left: 15,
                  right: 15,
                  bottom: 15
                ),
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.3),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)
                  )
                ),
                child: Column(              
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                      margin: EdgeInsets.only(
                        bottom: 5
                      ),
                      child: ListTile(
                      tileColor: Colors.white,
                      trailing: Icon(Icons.keyboard_arrow_right),
                      title: Text("Hakan Sasusagi"),                 
                      leading: Icon(Icons.supervised_user_circle),
                    ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        bottom: 5
                      ),
                      child: ListTile(
                      tileColor: Colors.white,
                      trailing: Icon(Icons.keyboard_arrow_right),
                      title: Text("Mert Tiryaki"),                 
                      leading: Icon(Icons.supervised_user_circle),
                    ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        bottom: 5
                      ),
                      child: ListTile(
                      tileColor: Colors.white,
                      trailing: Icon(Icons.keyboard_arrow_right),
                      title: Text("Alper Sipahi"),                 
                      leading: Icon(Icons.supervised_user_circle),
                    ),
                    )
                        ],
                      ),
                    ),
                    ),
                    Expanded(    
                      flex: 2,                
                      child: Container(
                        padding: EdgeInsets.only(
                          bottom: 10
                        ),
                        width: double.infinity,
                        height: double.infinity,
                      child: Column( 
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,                   
                        children: <Widget>[
                          CircleAvatar(
                            maxRadius: 35,
                            minRadius: 25,
                            backgroundColor: Colors.grey,
                             child: Icon(Icons.add),
                          ),
                          RaisedButton(
                            color: Colors.grey,
                            child: Text("report damage", style: TextStyle(color: Colors.white, fontFamily: "Ralewayto"),),
                            onPressed: (){}
                          ),
                          
                        ],
                      ),
                    ),
                    )
                    
                  ],
                ),
              ),
            ),
          ],
      ),
    )); 
  }
  expandedDondur(){
    return Expanded(
                      flex: 8,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 8,
                            child: Container(                             
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(17),
                                image: DecorationImage(
                                  image: AssetImage("assets/images/kedi.jpg"),
                                  fit: BoxFit.cover
                                )
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          Expanded(
                            flex: 8,
                            child: Container(                             
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(17),
                                image: DecorationImage(
                                  image: AssetImage("assets/images/kedi.jpg"),
                                  fit: BoxFit.cover
                                )
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          Expanded(
                            flex: 8,
                            child: Container(                             
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(17),
                                image: DecorationImage(
                                  image: AssetImage("assets/images/kedi.jpg"),
                                  fit: BoxFit.cover
                                )
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
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

  Future<List<MeetingAreaModel>> meetingAreaApiCall() async {
  http.Response response =
  await http.get("https://quakekit-api.hbksoftware.com.tr/api/MeetingArea");
  List responseJson = json.decode(response.body);
  return responseJson.map((m) => new MeetingAreaModel.fromJson(m)).toList();
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

  double zoomVal=5.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _buildGoogleMap(context),
          _zoomminusfunction(),
          _zoomplusfunction(),
          _buildContainer(),
        ],
      ),
    );
  }

  Widget _zoomminusfunction() {

    return Align(
      alignment: Alignment.topLeft,
      child: IconButton(
          icon: Icon(FontAwesomeIcons.searchMinus,color:Color(0xff6200ee)),
          onPressed: () {
            zoomVal--;
            _minus( zoomVal);
          }),
    );
  }
  Widget _zoomplusfunction() {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
          icon: Icon(FontAwesomeIcons.searchPlus,color:Color(0xff6200ee)),
          onPressed: () {
            zoomVal++;
            _plus(zoomVal);
          }),
    );
  }

  Future<void> _minus(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(40.712776, -74.005974), zoom: zoomVal)));
  }
  Future<void> _plus(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(40.712776, -74.005974), zoom: zoomVal)));
  }

  Widget _buildContainer() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20.0),
        height: 150.0,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            SizedBox(width: 10.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _boxes(
                  "https://lh5.googleusercontent.com/p/AF1QipO3VPL9m-b355xWeg4MXmOQTauFAEkavSluTtJU=w225-h160-k-no",
                  40.738380, -73.988426,"Gramercy Tavern"),
            ),
            SizedBox(width: 10.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _boxes(
                  "https://lh5.googleusercontent.com/p/AF1QipMKRN-1zTYMUVPrH-CcKzfTo6Nai7wdL7D8PMkt=w340-h160-k-no",
                  40.761421, -73.981667,"Le Bernardin"),
            ),
            SizedBox(width: 10.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _boxes(
                  "https://images.unsplash.com/photo-1504940892017-d23b9053d5d4?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                  40.732128, -73.999619,"Blue Hill"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _boxes(String _image, double lat,double long,String restaurantName) {
    return  GestureDetector(
      onTap: () {
        _gotoLocation(lat,long);
      },
      child:Container(
        child: new FittedBox(
          child: Material(
              color: Colors.white,
              elevation: 14.0,
              borderRadius: BorderRadius.circular(24.0),
              shadowColor: Color(0x802196F3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: 180,
                    height: 200,
                    child: ClipRRect(
                      borderRadius: new BorderRadius.circular(24.0),
                      child: Image(
                        fit: BoxFit.fill,
                        image: NetworkImage(_image),
                      ),
                    ),),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: myDetailsContainer1(restaurantName),
                    ),
                  ),

                ],)
          ),
        ),
      ),
    );
  }

  Widget myDetailsContainer1(String restaurantName) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
              child: Text(restaurantName,
                style: TextStyle(
                    color: Color(0xff6200ee),
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold),
              )),
        ),
        SizedBox(height:5.0),
        Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                    child: Text(
                      "4.1",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 18.0,
                      ),
                    )),
                Container(
                  child: Icon(
                    FontAwesomeIcons.solidStar,
                    color: Colors.amber,
                    size: 15.0,
                  ),
                ),
                Container(
                  child: Icon(
                    FontAwesomeIcons.solidStar,
                    color: Colors.amber,
                    size: 15.0,
                  ),
                ),
                Container(
                  child: Icon(
                    FontAwesomeIcons.solidStar,
                    color: Colors.amber,
                    size: 15.0,
                  ),
                ),
                Container(
                  child: Icon(
                    FontAwesomeIcons.solidStar,
                    color: Colors.amber,
                    size: 15.0,
                  ),
                ),
                Container(
                  child: Icon(
                    FontAwesomeIcons.solidStarHalf,
                    color: Colors.amber,
                    size: 15.0,
                  ),
                ),
                Container(
                    child: Text(
                      "(946)",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 18.0,
                      ),
                    )),
              ],
            )),
        SizedBox(height:5.0),
        Container(
            child: Text(
              "American \u00B7 \u0024\u0024 \u00B7 1.6 mi",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 18.0,
              ),
            )),
        SizedBox(height:5.0),
        Container(
            child: Text(
              "Closed \u00B7 Opens 17:00 Thu",
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            )),
      ],
    );
  }

  @override
  Widget _buildGoogleMap(BuildContext context) {
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
              markers: {
                gramercyMarker         
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
  Future<void> _gotoLocation(double lat,double long) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(lat, long), zoom: 15,tilt: 50.0,
      bearing: 45.0,)));
  }
}



Marker gramercyMarker = Marker(
  markerId: MarkerId('gramercy'),
  position: LatLng(40.738380, -73.988426),
  infoWindow: InfoWindow(title: 'Gramercy Tavern'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueViolet,
  ),
);

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

Future<List<EarthQuakeModel>> quakeCall() async {
  http.Response response =
      await http.get("https://quakekit-api.hbksoftware.com.tr/api/EarthQuake");
  List responseJson = json.decode(response.body);
  return responseJson.map((m) => new EarthQuakeModel.fromJson(m)).toList();
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
        body: FutureBuilder<List<EarthQuakeModel>>(
          future: quakeCall(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Container();
            List<EarthQuakeModel> earthQuakeModel = snapshot.data;
            return ListView.builder(
              itemCount: 50,
              itemBuilder: (context,index){
                return Container(
                  margin: EdgeInsets.only(
                    bottom: 5
                  ),
                  color: Colors.grey[400],
                  child: ListTile(                              
                  trailing: earthQuakeModel.map((earthQuake) => Text("Büyüklük:  " + earthQuake.eqSize)).toList().elementAt(index),
                  title: earthQuakeModel.map((earthQuake) => Text(earthQuake.eqLocationName)).toList().elementAt(index),
                  subtitle: earthQuakeModel.map((earthQuake) => Text(earthQuake.eqTime + "   " + earthQuake.eqDate)).toList().elementAt(index),                           
                  ),
                );
              }
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
