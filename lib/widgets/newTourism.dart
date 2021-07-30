import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../allNotifier/authNotifier.dart';
import '../allNotifier/newDestNotifier.dart';
import 'package:provider/provider.dart';
import '../screens/detailNewDest.dart';

class NewTourisms extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    NewDestNotifier newDestNotifier = Provider.of<NewDestNotifier>(context);
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    String emailAddress = authNotifier.user.email;
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "New Tourisms",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              Text(
                "See All",
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 12.0,
                    letterSpacing: 1.0),
              )
            ],
          ),
        ),
        Container(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: newDestNotifier.newDestinationList.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  newDestNotifier.currentNewDest =
                      newDestNotifier.newDestinationList[index];
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) {
                    return DetailNewDestination(
                      emailAddress: emailAddress,
                      idItem: newDestNotifier.newDestinationList[index].idItem,
                    );
                  }));
                },
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  width: 240,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 6.0,
                              color: Colors.black26,
                              offset: Offset(0.0, 2.0),
                            )
                          ],
                        ),
                        child: Stack(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Image(
                                height: 210.0,
                                width: 200.0,
                                image: NetworkImage(
                                  newDestNotifier.newDestinationList[index]
                                              .image ==
                                          null
                                      ? 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg'
                                      : newDestNotifier
                                          .newDestinationList[index].image,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              left: 10.0,
                              top: 10.0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    newDestNotifier
                                            .newDestinationList[index].name ??
                                        "no name",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        FontAwesomeIcons.locationArrow,
                                        size: 10.0,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      Text(
                                        newDestNotifier
                                                .newDestinationList[index]
                                                .village ??
                                            "no village",
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
