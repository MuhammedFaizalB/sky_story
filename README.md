
# Sky Story

**Sky Story** is a beautiful weather application built with Flutter. It provides current weather conditions and hourly/daily forecasts for cities around the world, using data from the [OpenWeather API](https://openweathermap.org/api).

## Features

- 🌦️ Current weather details (temperature, condition, humidity, wind, pressure, etc.)
- 🕒 Hourly and daily weather forecasts
- 🔍 Search for any city worldwide
- ⚡ Modern UI and smooth performance
- 🧩 Bloc state management for clean architecture
- 📱 Works on Android, iOS, and Web


## Getting Started

### 1. Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- An OpenWeather API key — [Get one here](https://openweathermap.org/appid)

### 2. Clone the Repository

```sh
git clone https://github.com/MuhammedFaizalB/sky_story
cd sky_story
```

### 3. Install Dependencies

```sh
flutter pub get
```

### 4. Add Your OpenWeather API Key

Create a file called `secrets.dart` or add your API key where it is referenced in the project:

```dart
const String openWeatherApiKey = "YOUR_OPENWEATHER_API_KEY";
```

Or use environment variables or `.env` files as you prefer.

### 5. Run the App

```sh
flutter run
```
Or run for specific platforms:

```sh
flutter run -d chrome     # For web
flutter run -d android    # For Android
flutter run -d ios        # For iOS (MacOS only)
```

## Project Structure

```
lib/
  ├── bloc/                # Bloc state management files
  ├── data/                # API services and repository
  ├── presentation/        # UI screens and widgets
  ├── models/              # weather models
  └── main.dart
```

## How It Works

- The app fetches current weather and forecast data from OpenWeather API (using the `/forecast` or `/weather` endpoints).
- Data is parsed into Dart models and managed using the Bloc pattern for responsive UI updates.
- Users can enter a city name to view weather details and forecast for any location.

## Dependencies

- [flutter_bloc](https://pub.dev/packages/flutter_bloc)
- [http](https://pub.dev/packages/http)


## Credits

- Weather data provided by [OpenWeather](https://openweathermap.org/)

**Sky Story — Experience the weather, beautifully.**
