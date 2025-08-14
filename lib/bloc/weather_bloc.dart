import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/data/repository/weather_repository.dart';
import 'package:weather_app/models/weather_model.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(WeatherInitial()) {
    on<LiveWeatherFetched>(_getLiveWeatherData);
    on<WeatherFetched>(_getWeatherData);
  }

  void _getLiveWeatherData(
    LiveWeatherFetched event,
    Emitter<WeatherState> emit,
  ) async {
    emit(WeatherLoading());
    late double latitude;
    late double longitude;
    Future<void> getUserLocation() async {
      bool serviceEnabled;
      LocationPermission permission = await Geolocator.checkPermission();
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return emit(LiveWeatherFailure());
      }
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return emit(LiveWeatherFailure());
        }
      }
      if (permission == LocationPermission.deniedForever) {
        return emit(LiveWeatherFailure());
      }
      final locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
      );
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );

      latitude = position.latitude;
      longitude = position.longitude;
    }

    try {
      await getUserLocation();
      final liveWeather = await WeatherRepository().getLiveWeather(
        latitude,
        longitude,
      );
      emit(WeatherSuccess(weatherModel: liveWeather));
    } catch (e) {
      emit(LiveWeatherFailure());
    }
  }

  void _getWeatherData(WeatherFetched event, Emitter<WeatherState> emit) async {
    emit(WeatherLoading());
    try {
      final weather = await WeatherRepository().getWeather(event.cityName);
      emit(WeatherSuccess(weatherModel: weather));
    } catch (e) {
      emit(WeatherFailure());
    }
  }
}
