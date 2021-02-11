import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'detailcard.dart';
import 'tambahdata.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD Apps',
      home: SearchListView(),
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SearchListView extends StatefulWidget {
  @override
  _SearchListViewState createState() => _SearchListViewState();
}

class _SearchListViewState extends State<SearchListView> {
  bool loading = true;
  var listDisplay = [], listBackup = [];
  TextEditingController ec = TextEditingController();

//method ambil data ini mempunyai variabel respon yang dimana datanya diambil dari api nya melalui json decode yang di taruh di body

  Future<void> ambilData() async {
    final response =
        await http.get("http://192.168.10.24/tokocrud/ambildata.php");
    var list = json.decode(response.body);
    setState(() {
      listDisplay.addAll(list);
      listBackup.addAll(list);
      loading = false;
    });
  }

  // pembungkusData() {
  //   ambilData().then((data) {
  //     listDisplay.addAll(data);
  //     listBackup.addAll(data);
  //     setState(() {});
  //   });
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   ambilData();
  //   pembungkusData();
  // }

  //Init state adalah waktu pertama kali buka aplikasi kemudian ada method ambilData() lalu kita buat methodnya
  @override
  void initState() {
    ambilData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Aplikasi CRUD')),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 50,
                  margin: EdgeInsets.only(left: 10, bottom: 10.0, top: 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26.0),
                    color: Colors.white,
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      icon: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Icon(Icons.search),
                      ),
                      hintText: "Cari Barangmu :",
                      contentPadding: EdgeInsets.only(left: 5),
                      border: InputBorder.none,
                    ),
                    controller: ec,
                    onChanged: (value) {
                      setState(() {
                        listDisplay = listDisplay
                            .where((e) => "${e['nama']}"
                                .toLowerCase()
                                .contains(ec.text.toLowerCase()))
                            .toList();
                        if (value.isEmpty) {
                          listDisplay = listBackup;
                        }
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        //karena default loading true maka tampilan pertama kali akan loading dan jika sudah di set state artinya datanya mau ditambah atau ditampilkan
        //maka sudah tidak loading dan datanya sudah ditampilkan 
        child: loading == false
            ? ItemList(
                list: listDisplay,
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) => TambahData()),
        ),
      ),
    );
  }
}

class ItemList extends StatelessWidget {
  final List list;
  ItemList({this.list});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, i) {
        return Container(
          padding: EdgeInsets.all(10),
          child: GestureDetector(
            //supaya kalau di klik bisa menampilkan detail card
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                //list value beraasal dari detailcard.dart
                builder: (BuildContext context) => DetailCard(
                      list: list,
                      index: i,
                    ))),
            child: Card(
              margin: EdgeInsets.all(5),
              child: ListTile(
                title: Text(
                  list[i]['nama'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                leading: Icon(Icons.add_shopping_cart),
                subtitle: Text("Harga Rp. ${list[i]['harga']}"),
                trailing: new Image.network(
                  'http://192.168.10.24/tokocrud/images/' + list[i]['gambar'],
                  fit: BoxFit.cover,
                  height: 60.0,
                  width: 60.0,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
