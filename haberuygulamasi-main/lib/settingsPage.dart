import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        alignment: Alignment.bottomCenter,
        child: Column(
          children: [
            Padding(child: RaisedButton(
              color: Colors.blue,textColor: Colors.white,
              onPressed: () {
                showLicensePage(
                  context: context,
                  applicationName: "Günlük Haberler",
                  applicationVersion: "1.0.0",
                  applicationLegalese: "Berkant Telli tarafından geliştirildi"
                );
              },
              child: Text("Lisanlar",style: TextStyle(),),
            ),padding: EdgeInsets.only(top:130.0),),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text("Uygulama Versiyonu: 1.0.0"),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text("Berkant Telli tarafından geliştirildi"),
            )
          ],
        ),
      ),
    );
  }
}

void showLicensePage({
  @required BuildContext context,
  String applicationName,
  String applicationVersion,
  Widget applicationIcon,
  String applicationLegalese,
  bool useRootNavigator = false,
}) {
  assert(context != null);
  assert(useRootNavigator != null);
  Navigator.of(context, rootNavigator: useRootNavigator)
      .push(MaterialPageRoute<void>(
    builder: (BuildContext context) => LicensePage(
      applicationName: applicationName,
      applicationVersion: applicationVersion,
      applicationIcon: applicationIcon,
      applicationLegalese: applicationLegalese,
    ),
  ));
}
