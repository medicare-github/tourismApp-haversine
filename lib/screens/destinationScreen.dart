import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../allNotifier/authNotifier.dart';
import '../allNotifier/ratingNotifier.dart';
import '../widgets/imput-text.dart';
import '../allNotifier/destinationNotifier.dart';
import 'package:provider/provider.dart';
import '../api/destinationApi.dart';
import '../allNotifier/newDestNotifier.dart';
import '../screens/detailToMap.dart';
import '../models/rating_model.dart';
import '../widgets/loadingScreen.dart';
import '../api/ratingApi.dart';
import '../screens/landingScreen.dart';
import 'home_screen.dart';

class DestinationScreen extends StatefulWidget {
  DestinationScreen({@required this.emailAddress, @required this.idItem});
  final emailAddress;
  final idItem;

  @override
  _DestinationScreenState createState() => _DestinationScreenState();
}

class _DestinationScreenState extends State<DestinationScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  Rating _rating = Rating();
  bool loading = false;
  int rating;
  double avgRate;

  @override
  void initState() {
    // TODO: implement initState
    _getValid();
    // getAllrating(widget.idItem);
    _getGrantod();
    super.initState();
  }

  _getGrantod() async {
    double b = await getAllrating(widget.idItem);
    avgRate = b;
    setState(() {});
  }

  _getValid() async {
    int a = await getValidRating(widget.emailAddress, widget.idItem);
    setState(() {
      rating = a;
    });
  }

  _saveRating(String email, String idItem, String nameDest) async {
    if (!_formkey.currentState.validate()) {
    } else {
      _formkey.currentState.save();
      print(_rating.rating);
      print(email);
      print(idItem);

      await ratingAdd(idItem, email, _rating.rating);
    }
    setState(() {
      loading = false;
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => LandingScreen(
          notif: nameDest,
        ),
      ),
    );
  }

  _showDialog(String email, String idItem, String nameDes) {
    return showDialog(
      // barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('Please Input Rating')),
          content: Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Form(
              autovalidate: true,
              key: _formkey,
              child: Column(
                children: <Widget>[
                  TextInputField(
                    inputType: TextInputType.number,
                    hint: "Input",
                    inputAction: TextInputAction.done,
                    validate: (String value) {
                      try {
                        if (value.isEmpty) {
                          return 'only required 1 until 5';
                        } else if (int.parse(value) > 5) {
                          return 'only required 1 until 5';
                        } else if (int.parse(value) < 1) {
                          return 'only required 1 until 5';
                        }
                      } catch (e) {
                        return 'only required 1 until 5';
                      }

                      return null;
                    },
                    onSaved: (String value) {
                      _rating.rating = int.parse(value);
                      Navigator.pop(context);
                      setState(() {
                        loading = true;
                      });
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      _saveRating(email, idItem, nameDes);
                    },
                    child: Container(
                      height: 40,
                      width: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.green),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          child: Text(
                            "save",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    DestinationNotifier destinationNotifier =
        Provider.of<DestinationNotifier>(context);
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    String email = authNotifier.user.email;

    Future<void> _refreshList() async {
      getDestinations(destinationNotifier);
    }

    return Scaffold(
      body: loading
          ? Loading()
          : new RefreshIndicator(
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30.0),
                            bottomRight: Radius.circular(30.0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 6.0,
                              color: Colors.black26,
                              offset: Offset(0.0, 2.0),
                            ),
                          ],
                        ),
                        child: Hero(
                          tag: destinationNotifier.currentDestination.image,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30.0),
                              bottomRight: Radius.circular(30.0),
                            ),
                            child: Image(
                              image: NetworkImage(destinationNotifier
                                          .currentDestination.image !=
                                      null
                                  ? destinationNotifier.currentDestination.image
                                  : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 30.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.arrow_back),
                              color: Colors.black,
                              onPressed: () => Navigator.pop(context),
                              iconSize: 30,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 6.0,
                                      offset: Offset(0.0, 0.1),
                                      color: Colors.white12),
                                ],
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 6.0,
                                          offset: Offset(0.0, 0.1),
                                          color: Colors.white12),
                                    ],
                                    color: Colors.grey),
                                child: IconButton(
                                  icon: Icon(Icons.location_on),
                                  color: Colors.green,
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) {
                                      return DetailToMap(
                                        idItem: destinationNotifier
                                            .currentDestination.idItem,
                                      );
                                    }));
                                  },
                                  iconSize: 30,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        left: 20.0,
                        bottom: 20.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              destinationNotifier.currentDestination.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24.0,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.2,
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Icon(
                                  FontAwesomeIcons.book,
                                  size: 10.0,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 6.0,
                                            offset: Offset(0.0, 0.1),
                                            color: Colors.white12),
                                      ],
                                      color: Colors.grey),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      destinationNotifier
                                          .currentDestination.description,
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 10.0,
                      bottom: 10.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          height: 40,
                          width: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 1.0,
                                color: Colors.orange,
                                offset: Offset(0.0, 1.0),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Icon(
                                    Icons.star,
                                    color: Colors.orange,
                                    size: 14,
                                  ),
                                  Text(
                                    avgRate != null ? avgRate.toString() : "0",
                                    style: TextStyle(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        rating != 0
                            ? Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.grey),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    "already rating",
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  _showDialog(
                                    email,
                                    destinationNotifier
                                        .currentDestination.idItem,
                                    destinationNotifier.currentDestination.name,
                                  );
                                },
                                child: Container(
                                  height: 40,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(10.0),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 1.0,
                                        color: Colors.black26,
                                        offset: Offset(0.0, 1.0),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Center(
                                      child: Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.add,
                                            size: 26,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            "add Rating",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )

                        // : Container(
                        //     child: Text("sudah"),
                        //   ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.only(bottom: 10.0),
                      itemCount: destinationNotifier.destinationList.length,
                      itemBuilder: (BuildContext context, int i) {
                        return Stack(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.fromLTRB(40.0, 5.0, 20.0, 5.0),
                              height: 170.0,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    100.0, 20.0, 20.0, 20.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          width: 120,
                                          child: Text(
                                            destinationNotifier
                                                .destinationList[i].name,
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      destinationNotifier
                                          .destinationList[i].village,
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    // Text('${activity.rating} *'),
                                    Text(
                                      destinationNotifier
                                          .destinationList[i].description,
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w300,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 4,
                                    ),
                                    // Text('${activity.rating} *'),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              left: 20.0,
                              top: 15.0,
                              bottom: 15.0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Image(
                                  width: 110.0,
                                  image: NetworkImage(
                                    destinationNotifier
                                                .destinationList[i].image !=
                                            null
                                        ? destinationNotifier
                                            .destinationList[i].image
                                        : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  )
                ],
              ),
              onRefresh: _refreshList,
            ),
    );
  }
}
