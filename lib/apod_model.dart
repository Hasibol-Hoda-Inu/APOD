class ApodModel {
  String? date;
  String? explanation;
  String? hdurl;
  String? mediaType;
  String? serviceVersion;
  String? title;
  String? url;

  ApodModel(
      {this.date,
        this.explanation,
        this.hdurl,
        this.mediaType,
        this.serviceVersion,
        this.title,
        this.url});

  ApodModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    explanation = json['explanation'];
    hdurl = json['hdurl'];
    mediaType = json['media_type'];
    serviceVersion = json['service_version'];
    title = json['title'];
    url = json['url'];
  }
}
