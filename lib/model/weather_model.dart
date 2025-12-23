class WeatherResponse {
  int? queryCost;
  double? latitude;
  double? longitude;
  String? resolvedAddress;
  String? address;
  String? timezone;
  double? tzoffset;
  String? description;
  List<Days>? days;
  // List<Null>? alerts;
  Stations? stations;
  CurrentConditions? currentConditions;

  WeatherResponse({
    this.queryCost,
    this.latitude,
    this.longitude,
    this.resolvedAddress,
    this.address,
    this.timezone,
    this.tzoffset,
    this.description,
    this.days,
    // this.alerts,
    this.stations,
    this.currentConditions,
  });

  WeatherResponse.fromJson(Map<String, dynamic> json) {
    queryCost = json['queryCost'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    resolvedAddress = json['resolvedAddress'];
    address = json['address'];
    timezone = json['timezone'];
    tzoffset = (json['tzoffset']);
    description = json['description'];
    if (json['days'] != null) {
      days = <Days>[];
      json['days'].forEach((v) {
        days!.add(new Days.fromJson(Map<String, dynamic>.from(v)));
      });
    }
    // if (json['alerts'] != null) {
    //   alerts = <Null>[];
    //   json['alerts'].forEach((v) {
    //     alerts!.add(new Null.fromJson(v));
    //   });
    // }
    stations = json['stations'] != null
        ? new Stations.fromJson(Map<String, dynamic>.from(json['stations']))
        : null;
    currentConditions = json['currentConditions'] != null
        ? new CurrentConditions.fromJson(Map<String, dynamic>.from(json['currentConditions']))
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['queryCost'] = this.queryCost;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['resolvedAddress'] = this.resolvedAddress;
    data['address'] = this.address;
    data['timezone'] = this.timezone;
    data['tzoffset'] = this.tzoffset;
    data['description'] = this.description;
    if (this.days != null) {
      data['days'] = this.days!.map((v) => v.toJson()).toList();
    }
    // if (this.alerts != null) {
    //   data['alerts'] = this.alerts!.map((v) => v.toJson()).toList();
    // }
    if (this.stations != null) {
      data['stations'] = this.stations!.toJson();
    }
    if (this.currentConditions != null) {
      data['currentConditions'] = this.currentConditions!.toJson();
    }
    return data;
  }
}

class Days {
  String? datetime;
  int? datetimeEpoch;
  double? tempmax;
  double? tempmin;
  double? temp;
  double? feelslikemax;
  double? feelslikemin;
  double? feelslike;
  double? dew;
  double? humidity;
  double? precip;
  double? precipprob;
  double? precipcover;
  List<dynamic>? preciptype;
  double? snow;
  double? snowdepth;
  double? windgust;
  double? windspeed;
  double? winddir;
  double? pressure;
  double? cloudcover;
  double? visibility;
  double? solarradiation;
  double? solarenergy;
  double? uvindex;
  double? severerisk;
  String? sunrise;
  int? sunriseEpoch;
  String? sunset;
  int? sunsetEpoch;
  double? moonphase;
  String? conditions;
  String? description;
  String? icon;
  List<dynamic>? stations;
  String? source;
  List<Hours>? hours;

  Days({
    this.datetime,
    this.datetimeEpoch,
    this.tempmax,
    this.tempmin,
    this.temp,
    this.feelslikemax,
    this.feelslikemin,
    this.feelslike,
    this.dew,
    this.humidity,
    this.precip,
    this.precipprob,
    this.precipcover,
    this.preciptype,
    this.snow,
    this.snowdepth,
    this.windgust,
    this.windspeed,
    this.winddir,
    this.pressure,
    this.cloudcover,
    this.visibility,
    this.solarradiation,
    this.solarenergy,
    this.uvindex,
    this.severerisk,
    this.sunrise,
    this.sunriseEpoch,
    this.sunset,
    this.sunsetEpoch,
    this.moonphase,
    this.conditions,
    this.description,
    this.icon,
    this.stations,
    this.source,
    this.hours,
  });

  Days.fromJson(Map<String, dynamic> json) {
    datetime = json['datetime'];
    datetimeEpoch = json['datetimeEpoch'];
    tempmax = json['tempmax'];
    tempmin = json['tempmin'];
    temp = json['temp'];
    feelslikemax = json['feelslikemax'];
    feelslikemin = json['feelslikemin'];
    feelslike = json['feelslike'];
    dew = json['dew'];
    humidity = json['humidity'];
    precip = json['precip'];
    precipprob = json['precipprob'];
    precipcover = json['precipcover'];
    preciptype = json['preciptype'];
    snow = json['snow'];
    snowdepth = json['snowdepth'];
    windgust = json['windgust'];
    windspeed = json['windspeed'];
    winddir = json['winddir'];
    pressure = json['pressure'];
    cloudcover = json['cloudcover'];
    visibility = json['visibility'];
    solarradiation = json['solarradiation'];
    solarenergy = json['solarenergy'];
    uvindex = json['uvindex'];
    severerisk = json['severerisk'];
    sunrise = json['sunrise'];
    sunriseEpoch = json['sunriseEpoch'];
    sunset = json['sunset'];
    sunsetEpoch = json['sunsetEpoch'];
    moonphase = json['moonphase'];
    conditions = json['conditions'];
    description = json['description'];
    icon = json['icon'];
    stations = json['stations'];
    source = json['source'];
    if (json['hours'] != null) {
      hours = <Hours>[];
      json['hours'].forEach((v) {
        hours!.add(new Hours.fromJson(Map<String, dynamic>.from(v)));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['datetime'] = this.datetime;
    data['datetimeEpoch'] = this.datetimeEpoch;
    data['tempmax'] = this.tempmax;
    data['tempmin'] = this.tempmin;
    data['temp'] = this.temp;
    data['feelslikemax'] = this.feelslikemax;
    data['feelslikemin'] = this.feelslikemin;
    data['feelslike'] = this.feelslike;
    data['dew'] = this.dew;
    data['humidity'] = this.humidity;
    data['precip'] = this.precip;
    data['precipprob'] = this.precipprob;
    data['precipcover'] = this.precipcover;
    data['preciptype'] = this.preciptype;
    data['snow'] = this.snow;
    data['snowdepth'] = this.snowdepth;
    data['windgust'] = this.windgust;
    data['windspeed'] = this.windspeed;
    data['winddir'] = this.winddir;
    data['pressure'] = this.pressure;
    data['cloudcover'] = this.cloudcover;
    data['visibility'] = this.visibility;
    data['solarradiation'] = this.solarradiation;
    data['solarenergy'] = this.solarenergy;
    data['uvindex'] = this.uvindex;
    data['severerisk'] = this.severerisk;
    data['sunrise'] = this.sunrise;
    data['sunriseEpoch'] = this.sunriseEpoch;
    data['sunset'] = this.sunset;
    data['sunsetEpoch'] = this.sunsetEpoch;
    data['moonphase'] = this.moonphase;
    data['conditions'] = this.conditions;
    data['description'] = this.description;
    data['icon'] = this.icon;
    data['stations'] = this.stations;
    data['source'] = this.source;
    if (this.hours != null) {
      data['hours'] = this.hours!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Hours {
  String? datetime;
  int? datetimeEpoch;
  double? temp;
  double? feelslike;
  double? humidity;
  double? dew;
  double? precip;
  double? precipprob;
  double? snow;
  double? snowdepth;
  List<dynamic>? preciptype;
  double? windgust;
  double? windspeed;
  double? winddir;
  double? pressure;
  double? visibility;
  double? cloudcover;
  double? solarradiation;
  double? solarenergy;
  double? uvindex;
  double? severerisk;
  String? conditions;
  String? icon;
  List<dynamic>? stations;
  String? source;

  Hours({
    this.datetime,
    this.datetimeEpoch,
    this.temp,
    this.feelslike,
    this.humidity,
    this.dew,
    this.precip,
    this.precipprob,
    this.snow,
    this.snowdepth,
    this.preciptype,
    this.windgust,
    this.windspeed,
    this.winddir,
    this.pressure,
    this.visibility,
    this.cloudcover,
    this.solarradiation,
    this.solarenergy,
    this.uvindex,
    this.severerisk,
    this.conditions,
    this.icon,
    this.stations,
    this.source,
  });

  Hours.fromJson(Map<String, dynamic> json) {
    datetime = json['datetime'];
    datetimeEpoch = json['datetimeEpoch'];
    temp = json['temp'];
    feelslike = json['feelslike'];
    humidity = json['humidity'];
    dew = json['dew'];
    precip = json['precip'];
    precipprob = json['precipprob'];
    snow = json['snow'];
    snowdepth = json['snowdepth'];
    preciptype = json['preciptype'];
    windgust = json['windgust'];
    windspeed = json['windspeed'];
    winddir = json['winddir'];
    pressure = json['pressure'];
    visibility = json['visibility'];
    cloudcover = json['cloudcover'];
    solarradiation = json['solarradiation'];
    solarenergy = json['solarenergy'];
    uvindex = json['uvindex'];
    severerisk = json['severerisk'];
    conditions = json['conditions'];
    icon = json['icon'];
    stations = json['stations'];
    source = json['source'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['datetime'] = this.datetime;
    data['datetimeEpoch'] = this.datetimeEpoch;
    data['temp'] = this.temp;
    data['feelslike'] = this.feelslike;
    data['humidity'] = this.humidity;
    data['dew'] = this.dew;
    data['precip'] = this.precip;
    data['precipprob'] = this.precipprob;
    data['snow'] = this.snow;
    data['snowdepth'] = this.snowdepth;
    data['preciptype'] = this.preciptype;
    data['windgust'] = this.windgust;
    data['windspeed'] = this.windspeed;
    data['winddir'] = this.winddir;
    data['pressure'] = this.pressure;
    data['visibility'] = this.visibility;
    data['cloudcover'] = this.cloudcover;
    data['solarradiation'] = this.solarradiation;
    data['solarenergy'] = this.solarenergy;
    data['uvindex'] = this.uvindex;
    data['severerisk'] = this.severerisk;
    data['conditions'] = this.conditions;
    data['icon'] = this.icon;
    data['stations'] = this.stations;
    data['source'] = this.source;
    return data;
  }
}

class Stations {
  EGWU? eGWU;
  EGWU? eGLC;
  EGWU? eGLL;
  EGWU? d5621;
  EGWU? f6665;

  Stations({this.eGWU, this.eGLC, this.eGLL, this.d5621, this.f6665});

  Stations.fromJson(Map<String, dynamic> json) {
    eGWU = json['EGWU'] != null ? new EGWU.fromJson(Map<String, dynamic>.from(json['EGWU'])) : null;
    eGLC = json['EGLC'] != null ? new EGWU.fromJson(Map<String, dynamic>.from(json['EGLC'])) : null;
    eGLL = json['EGLL'] != null ? new EGWU.fromJson(Map<String, dynamic>.from(json['EGLL'])) : null;
    d5621 = json['D5621'] != null ? new EGWU.fromJson(Map<String, dynamic>.from(json['D5621'])) : null;
    f6665 = json['F6665'] != null ? new EGWU.fromJson(Map<String, dynamic>.from(json['F6665'])) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.eGWU != null) {
      data['EGWU'] = this.eGWU!.toJson();
    }
    if (this.eGLC != null) {
      data['EGLC'] = this.eGLC!.toJson();
    }
    if (this.eGLL != null) {
      data['EGLL'] = this.eGLL!.toJson();
    }
    if (this.d5621 != null) {
      data['D5621'] = this.d5621!.toJson();
    }
    if (this.f6665 != null) {
      data['F6665'] = this.f6665!.toJson();
    }
    return data;
  }
}

class EGWU {
  double? distance;
  double? latitude;
  double? longitude;
  int? useCount;
  String? id;
  String? name;
  int? quality;
  double? contribution;

  EGWU({
    this.distance,
    this.latitude,
    this.longitude,
    this.useCount,
    this.id,
    this.name,
    this.quality,
    this.contribution,
  });

  EGWU.fromJson(Map<String, dynamic> json) {
    distance = json['distance'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    useCount = json['useCount'];
    id = json['id'];
    name = json['name'];
    quality = json['quality'];
    contribution = json['contribution'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['distance'] = this.distance;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['useCount'] = this.useCount;
    data['id'] = this.id;
    data['name'] = this.name;
    data['quality'] = this.quality;
    data['contribution'] = this.contribution;
    return data;
  }
}

class CurrentConditions {
  String? datetime;
  int? datetimeEpoch;
  double? temp;
  double? feelslike;
  double? humidity;
  double? dew;
  double? precip;
  double? precipprob;
  double? snow;
  double? snowdepth;
  Null? preciptype;
  double? windgust;
  double? windspeed;
  double? winddir;
  double? pressure;
  double? visibility;
  double? cloudcover;
  double? solarradiation;
  double? solarenergy;
  double? uvindex;
  String? conditions;
  String? icon;
  List<String>? stations;
  String? source;
  String? sunrise;
  int? sunriseEpoch;
  String? sunset;
  int? sunsetEpoch;
  double? moonphase;

  CurrentConditions({
    this.datetime,
    this.datetimeEpoch,
    this.temp,
    this.feelslike,
    this.humidity,
    this.dew,
    this.precip,
    this.precipprob,
    this.snow,
    this.snowdepth,
    this.preciptype,
    this.windgust,
    this.windspeed,
    this.winddir,
    this.pressure,
    this.visibility,
    this.cloudcover,
    this.solarradiation,
    this.solarenergy,
    this.uvindex,
    this.conditions,
    this.icon,
    this.stations,
    this.source,
    this.sunrise,
    this.sunriseEpoch,
    this.sunset,
    this.sunsetEpoch,
    this.moonphase,
  });

  CurrentConditions.fromJson(Map<String, dynamic> json) {
    datetime = json['datetime'];
    datetimeEpoch = json['datetimeEpoch'];
    temp = json['temp'];
    feelslike = json['feelslike'];
    humidity = json['humidity'];
    dew = json['dew'];
    precip = json['precip'];
    precipprob = json['precipprob'];
    snow = json['snow'];
    snowdepth = json['snowdepth'];
    preciptype = json['preciptype'];
    windgust = json['windgust'];
    windspeed = json['windspeed'];
    winddir = json['winddir'];
    pressure = json['pressure'];
    visibility = json['visibility'];
    cloudcover = json['cloudcover'];
    solarradiation = json['solarradiation'];
    solarenergy = json['solarenergy'];
    uvindex = json['uvindex'];
    conditions = json['conditions'];
    icon = json['icon'];
    stations = json['stations'].cast<String>();
    source = json['source'];
    sunrise = json['sunrise'];
    sunriseEpoch = json['sunriseEpoch'];
    sunset = json['sunset'];
    sunsetEpoch = json['sunsetEpoch'];
    moonphase = json['moonphase'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['datetime'] = this.datetime;
    data['datetimeEpoch'] = this.datetimeEpoch;
    data['temp'] = this.temp;
    data['feelslike'] = this.feelslike;
    data['humidity'] = this.humidity;
    data['dew'] = this.dew;
    data['precip'] = this.precip;
    data['precipprob'] = this.precipprob;
    data['snow'] = this.snow;
    data['snowdepth'] = this.snowdepth;
    data['preciptype'] = this.preciptype;
    data['windgust'] = this.windgust;
    data['windspeed'] = this.windspeed;
    data['winddir'] = this.winddir;
    data['pressure'] = this.pressure;
    data['visibility'] = this.visibility;
    data['cloudcover'] = this.cloudcover;
    data['solarradiation'] = this.solarradiation;
    data['solarenergy'] = this.solarenergy;
    data['uvindex'] = this.uvindex;
    data['conditions'] = this.conditions;
    data['icon'] = this.icon;
    data['stations'] = this.stations;
    data['source'] = this.source;
    data['sunrise'] = this.sunrise;
    data['sunriseEpoch'] = this.sunriseEpoch;
    data['sunset'] = this.sunset;
    data['sunsetEpoch'] = this.sunsetEpoch;
    data['moonphase'] = this.moonphase;
    return data;
  }
}
