import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'country_codes.dart';
import '../../help/globals.dart' as globals;
import '../../model/login_api.dart';

class Countries extends StatefulWidget {
  const Countries({Key? key,}) : super(key: key);

  @override
  _CountriesState createState() => _CountriesState();
}

class _CountriesState extends State<Countries> {

  List codeList = [];
  List codeListData = [];
  var loading = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getIso(context);
    });

  }

  Future getIso(context)async{
    await LoginApi(context).getIso().then((value){
      if(value != false){
        setState((){
          codeList = value["data"];
          codeListData = value["data"];
        });
      }else{}
    });
  }

  _buildSearchList(String userSearchTerm) {
    List results = [];
    if(userSearchTerm.isEmpty) {
      codeList = codeListData;
    }else{
      for(var i in codeListData){
        i['name']!.toLowerCase().contains(userSearchTerm.toLowerCase()) ? results.add(i) : null;
      }
      codeList = results;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 100), child: Padding(
          padding: const EdgeInsets.only(top: 35),
          child: SizedBox(
          height: 50,
          child: Row(
            children: [
              GestureDetector(
                onTap: ()=> Navigator.of(context).pop(),
                child: const Padding(
                  padding: EdgeInsets.only(left: 20,right: 20),
                  child: Icon(Icons.arrow_back_ios),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: TextField(
                    cursorColor: const Color(0xffC00D1E),
                    decoration: const InputDecoration(border: InputBorder.none, hintText: 'ابحث عن البلد',contentPadding: EdgeInsets.only(left: 10)),
                    onChanged: (v){
                      _buildSearchList(v);
                    },
                  ),
                ),
              ),
            ],
          ),
      ),
        ),
      ),
      body: codeList.isEmpty ? Container() : ListView(
        children: List.generate(codeList.length, (index) => Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  ListTile(
                    leading: Image(image: NetworkImage('${codeList[index]['image']}'), height: 20,),
                    dense: true,
                    title: Text('${codeList[index]['name']}'),
                    trailing: Text('${codeList[index]['code']}'),
                    onTap: ()async{
                      setState(() {
                        globals.nameMyIso = codeList[index]["name"]!;  // تركيا
                        globals.nameMyIsoId = codeList[index]["id"]!;
                        globals.dialCodeMyIso = codeList[index]["code"]!; // +90
                        globals.flagMyIso = NetworkImage('${codeList[index]['image']}');
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                  const Divider()
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }
}



