import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../models/location_model.dart';
import '../models/result.dart';
import '../services/second_screen_service.dart' as service;
import 'package:weather_app/models/weather_model.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SecondScreenState();
  }
}

class SecondScreenState extends State<SecondScreen> {
  Result? result;
  Timer? timer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Weather")),
        body: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: [0.3, 0.6],
              colors: [Color(0xFF11998E), Color(0xFF38Ef7D)],
            )),
            child: Builder(
              builder: (BuildContext context) {
                return result == null
                    ? const Center(child: CircularProgressIndicator())
                    : ListView(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.network(
                                        "http://openweathermap.org/img/wn/${result?.currentWeatherData.icon}@2x.png"),
                                    Text(
                                        '${result?.currentWeatherData.temperature.toStringAsFixed(1)}')
                                  ]),
                              Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                        onPressed: () async {
                                          Result res = await fetchData();
                                          setState(() {
                                            result = res;
                                          });
                                        },
                                        child: const Icon(
                                            CupertinoIcons.location_solid)),
                                    Text('${((String? locality) {
                                      if (locality == null ||
                                          locality.isEmpty) {
                                        return '';
                                      } else {
                                        return '$locality, ';
                                      }
                                    })(result?.currentPlacemark.name)}${result?.currentWeatherData.name}'),

                                  ])
                            ],
                          ),
                          Center(
                              child: Column(
                            children: [
                              Text(
                                  '${result?.currentPosition.timestamp?.day}/${result?.currentPosition.timestamp?.month}/${result?.currentPosition.timestamp?.year} ${result?.currentPosition.timestamp?.hour}:${result?.currentPosition.timestamp?.minute}'),
                              Text('${result?.currentWeatherData.weather}'),
                            ],
                          ))
                        ],
                      );
              },
            )));
  }

  Future<Result> fetchData() async {
    Position position = await service.getCurrentPosition();
    LocationData placemark = await service.getAddressFromLatLng(position);
    WeatherData weatherData = await service.fetchWeatherData(position);
    Result result = Result(position, weatherData, placemark);
    return result;
  }

  @override
  void initState() {
    super.initState();
    fetchData().then((value) => {
          setState(() {
            result = value;
          })
        });
    timer = Timer.periodic(const Duration(minutes: 30), (timer) async {
      Result res = await fetchData();
      setState(() {
        result = res;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
