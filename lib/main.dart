import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as developer;

// Jenis Pinjaman
class JenisPinjamanModel {
  String id;
  String nama;
  JenisPinjamanModel({required this.id, required this.nama});
}

// Detail Pinjaman
class DetailPinjamanModel {
  String id;
  String nama;
  String bunga;
  String isSyariah;
  DetailPinjamanModel(
      {required this.id,
      required this.nama,
      required this.bunga,
      required this.isSyariah});
}

class JenisPinjamanCubit extends Cubit<JenisPinjamanModel> {
  String url = "http://178.128.17.76:8000/jenis_pinjaman";
  JenisPinjamanCubit() : super(JenisPinjamanModel(id: "", nama: ""));

  //map dari json ke atribut
  void setFromJson(Map<String, dynamic> json) {
    String id = json['id'];
    String nama = json['nama'];
    emit(JenisPinjamanModel(id: id, nama: nama));
  }

  void fetchData(String id) async {
    final response = await http.get(Uri.parse('$url/$id'));
    if (response.statusCode == 200) {
      setFromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal load');
    }
  }
}

class DetailPinjamanCubit extends Cubit<DetailPinjamanModel> {
  String url = "http://178.128.17.76:8000/detil_jenis_pinjaman";
  DetailPinjamanCubit()
      : super(DetailPinjamanModel(id: "", nama: "", bunga: "", isSyariah: ""));

  //map dari json ke atribut
  void setFromJson(Map<String, dynamic> json) {
    String id = json['id'];
    String nama = json['nama'];
    String bunga = json['bunga'];
    String isSyariah = json['is_syariah'];
    emit(DetailPinjamanModel(
        id: id, nama: nama, bunga: bunga, isSyariah: isSyariah));
  }

  void fetchData(String id) async {
    final response = await http.get(Uri.parse('$url/$id'));
    if (response.statusCode == 200) {
      setFromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal load');
    }
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: MultiBlocProvider(
      providers: [
        BlocProvider<JenisPinjamanCubit>(
          create: (BuildContext context) => JenisPinjamanCubit(),
        ),
        BlocProvider<DetailPinjamanCubit>(
          create: (BuildContext context) => DetailPinjamanCubit(),
        ),
      ],
      child: const HalamanUtama(),
    ));
  }
}

const List<String> listpilihanPeminjaman = <String>[
  'Pilih jenis peminjaman',
  'Jenis pinjaman 1',
  'Jenis pinjaman 2',
  'Jenis pinjaman 3'
];

class HalamanUtama extends StatefulWidget {
  const HalamanUtama({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HalamanUtamaState();
  }
}

class HalamanUtamaState extends State<HalamanUtama> {
  @override
  Widget build(Object context) {
    var pilihanPeminjaman = "Pilih jenis peminjaman";
    var id = "";
    return MaterialApp(
      title: 'Provis Quiz 3',
      home: Scaffold(
          appBar: AppBar(
            title: const Text('My App P2P'),
            centerTitle: true,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                      "2000879, Hilman Fauzi Herdiana; 2000107, Rizal Teddyansyah; Saya berjanji tidak akan berbuat curang data atau membantu orang lain berbuat curang"),
                ),
                Padding(
                    padding: const EdgeInsets.all(20),
                    child: DropdownButton<String>(
                      value: pilihanPeminjaman,
                      items: listpilihanPeminjaman
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        pilihanPeminjaman = value!;
                        if (pilihanPeminjaman == "Jenis pinjaman 1") {
                          id = "1";
                        } else if (pilihanPeminjaman == "Jenis pinjaman 2") {
                          id = "2";
                        } else if (pilihanPeminjaman == "Jenis pinjaman 3") {
                          id = "3";
                        } else {
                          id = "";
                        }
                      },
                    )),
                BlocBuilder<JenisPinjamanCubit, JenisPinjamanModel>(
                    builder: (context, jenispinjaman) {
                  context.read<JenisPinjamanCubit>().fetchData('2');
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                            padding: EdgeInsets.all(20),
                            child:
                                ListView.builder(itemBuilder: (context, index) {
                              return Container(
                                decoration: BoxDecoration(border: Border.all()),
                                padding: const EdgeInsets.all(14),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(jenispinjaman.nama),
                                    Text(jenispinjaman.id),
                                  ],
                                ),
                              );
                            })),
                      ],
                    ),
                  );
                })
              ],
            ),
          )),
    );
  }
}

class HalamanDetail extends StatelessWidget {
  const HalamanDetail({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(Object context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Detil'),
            centerTitle: true,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocBuilder<DetailPinjamanCubit, DetailPinjamanModel>(
                    builder: (context, detailPinjaman) {
                  context.read<DetailPinjamanCubit>().fetchData("5");
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 10),
                        ),
                        Text("id: ${detailPinjaman.id}"),
                        Text("nama: ${detailPinjaman.nama}"),
                        Text("bunga: ${detailPinjaman.bunga}"),
                        Text("Syariah: ${detailPinjaman.isSyariah}")
                      ],
                    ),
                  );
                })
              ],
            ),
          )),
    );
  }
}
