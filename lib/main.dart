import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as developer;

class ActivityModel {
  String aktivitas;
  String jenis;
  ActivityModel({required this.aktivitas, required this.jenis}); // constructor
}
class ActivityCubit extends Cubit<ActivityModel> {
  String url = "https://www.boredapi.com/api/activity";
  ActivityCubit() : super(ActivityModel(aktivitas: "", jenis: ""));
  

  //map dari json ke atribut
  void setFromJson(Map<String, dynamic> json) {
    String aktivitas = json['activity'];
    String jenis = json['type'];
    
    //emit state baru, ini berbeda dgn provider! 
    emit(ActivityModel(aktivitas: aktivitas, jenis: jenis));
  }

  void fetchData() async {
	  final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) { //sukses
        setFromJson(jsonDecode(response.body));
    } else {
        throw Exception('Gagal load');
    }
  }
}


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
  DetailPinjamanModel({required this.id, required this.nama, required this.bunga, required this.isSyariah});
}



class DaftarUMKMCubit extends Cubit<DaftarUMKMModel> {
  String url = "http://178.128.17.76:8000/daftar_umkm";
  DaftarUMKMCubit() : super(DaftarUMKMModel(id: "", nama: "", jenis: ""));

  //map dari json ke atribut
  void setFromJson(Map<String, dynamic> json) {
    String id = json['id'];
    String nama = json['nama'];
    String jenis = json['jenis'];
    
    //emit state baru, ini berbeda dgn provider! 
    emit(DaftarUMKMModel(id: id, nama: nama, jenis: jenis));
  }

   void fetchData() async {
	  final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) { //sukses
        setFromJson(jsonDecode(response.body));
    } else {
        throw Exception('Gagal load');
    }
  }
}



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget  {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider (
   	    create: (_) => ActivityCubit(),
   	    child: const HalamanUtama(),
      ),

      // MultiBlocProvider(
      //   providers: [
      //     BlocProvider<CubitA>(
      //       create: (BuildContext context) => CubitA(),
      //     ),
      //     BlocProvider<CubitB>(
      //       create: (BuildContext context) => CubitB(),
      //     ),
      //     BlocProvider<CubitC>(
      //       create: (BuildContext context) => CubitC(),
      //     ),
      //   ],
      //   child: ChildA(),
      // )

    );
  }
}

class HalamanUtama extends StatelessWidget {
  const HalamanUtama({Key? key}) : super(key: key);

  @override
  Widget build(Object context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocBuilder<ActivityCubit, ActivityModel> (
                buildWhen: (previousState, state) {
                  developer.log("${previousState.aktivitas}->${state.aktivitas}", name: 'logyudi');
                  return true; //selalu draw untuk kasus ini
                },
                builder: (context, aktivitas) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: ElevatedButton(
                            onPressed: () {
                              context.read<ActivityCubit>().fetchData();
                            }, 
                            child: const Text("Saya bosan ...")
                          ),
                        ),
                        Text(aktivitas.aktivitas),  //data terupdate di sini
           		          Text("Jenis: ${aktivitas.jenis}")
                      ],
                    ),
                  );
                }
              )
            ],
          ),
        )
      ),
    );
  }
}