import 'package:flutter/material.dart';
import 'updatedata.dart';
import 'package:http/http.dart' as http;
import 'main.dart';

class DetailCard extends StatefulWidget {
  final List list; //value dari textfield
  final int index;

  DetailCard({this.list, this.index});

  @override
  _DetailCardState createState() => _DetailCardState();
}

class _DetailCardState extends State<DetailCard> {
//(delete) 5.buat method dan buat file hapus.php nya, jangan lupa inport http nya dan buat library nya

  Future<void> hapusData() async {
    var url = "http://192.168.10.24/tokocrud/hapusdata.php";
    await http.post(url, body: {'id': widget.list[widget.index]['id']});
    //(delete)6.ketika sudah di hapus kembali ke halaman awal

    Navigator.pushAndRemoveUntil(
        context, //pergi ke a dari b dan menghapus b
        MaterialPageRoute(builder: (_) => SearchListView()),
        (route) => false);
  }

//(delete)2.buat method confirm
  void confirm() {
    showDialog(
      context: context, // cntext yang lagi dibicarakan pada waktu itu
      builder: (context) => AlertDialog(
        content:
            Text("Yakin ingin hapus '${widget.list[widget.index]['nama']}'"),
        actions: <Widget>[
          RaisedButton(
            child: Text(
              "HAPUS",
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.red,
            onPressed:
                hapusData, //(delete) 4. panggil methode delete ketika dipencet delete di state
          ),
          SizedBox(
            width: 5,
          ),
          RaisedButton(
              child: Text(
                "BATAL",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.green,
              onPressed: () {
                Navigator.pop(context);
              }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.list[widget.index]['nama']}"),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Card(
          child: Center(
            child: Column(
              children: <Widget>[
                Image.network("http://192.168.10.24/tokocrud/images/" +
                    widget.list[widget.index]['gambar']),
                SizedBox(
                  height: 10,
                ),
                Text(
                  widget.list[widget.index]['nama'],
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  " Kode : ${widget.list[widget.index]['kode']}",
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  " Harga Rp.: ${widget.list[widget.index]['harga']}",
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  " Stok : ${widget.list[widget.index]['stok']}",
                  style: TextStyle(fontSize: 20),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    RaisedButton(
                      child: Text(
                        "UPDATE",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.green,
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (BuildContext context) => UpdateData(
                                  list: widget.list,
                                  index: widget.index,
                                )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                          child: Text(
                            "DELETE",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.red,
                          onPressed: () {
                            confirm();
                          }
                          //1.(delete) panggil method confirm
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
