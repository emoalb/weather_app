import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:weather_app/models/weather_forecast/weather_forecast_model.dart';
import '../models/location_model.dart';
import '../models/result.dart';
import '../services/home_screen_service.dart' as service;
import 'package:weather_app/models/weather_model.dart';

import '../services/notification_api.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  Result? result;
  WeatherForecastModel? model;
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
                    : ListView(children: [
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
                                        WeatherForecastModel mod = await fetchWeatherForecast();
                                        setState(() {
                                          result = res;
                                          model = mod;
                                        });
                                      },
                                      child: const Icon(
                                          CupertinoIcons.location_solid)),
                                  Text('${((String? locality) {
                                    if (locality == null || locality.isEmpty) {
                                      return '';
                                    } else {
                                      return '$locality, ';
                                    }
                                  })(result?.currentPlacemark.name)}${result?.currentWeatherData.name}'),
                                ]),
                          ],
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                  child: Column(
                                children: [
                                  Text(
                                      '${result?.currentPosition.timestamp?.day}/${result?.currentPosition.timestamp?.month}'
                                          '/${result?.currentPosition.timestamp?.year} ${result?.currentPosition.timestamp?.hour}:'
                                          '${result?.currentPosition.timestamp?.minute}'),
                                  Text('${result?.currentWeatherData.weather}'),
                                ],
                              ))
                            ]),
                        Container(
                            height: 150,
                            margin: const EdgeInsets.all(10.0),
                            child: Builder(builder: (BuildContext context) {
                              return model == null
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: model?.list.length,
                                      itemBuilder: (context, i) {
                                        return Container(
                                            margin: const EdgeInsets.all(10),
                                            height: 80,
                                            child: Column(children: [
                                              Text(model!.list[i].dt_txt),
                                              Text(model!.list[i].temperature.toStringAsFixed(1)),
                                              Image.network(
                                                  "http://openweathermap.org/img/wn/${model?.list[i].icon}.png"),
                                              Text(model!.list[i].weather)
                                            ]));
                                      });
                            })),
                      ]);
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

  Future<WeatherForecastModel> fetchWeatherForecast() async {
    Position position = await service.getCurrentPosition();
    WeatherForecastModel model = await service.fetchWeatherForecast(position);
    return model;
  }

  @override
  void initState() {
    super.initState();
    NotificationApi.init();
       fetchData().then((value) => {
          setState(() {
            result = value;
          })
        });

    fetchWeatherForecast().then((value) => {
          setState(() {
            model = value;
          })
        });

    timer = Timer.periodic(const Duration(seconds: 200), (timer) async {
      Result res = await fetchData();
      setState(() {
        result = res;
      });
      NotificationApi.showNotification(
          title: result?.currentWeatherData.temperature.toStringAsFixed(1),
          body: result?.currentPlacemark.name);
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
