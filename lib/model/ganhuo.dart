
class GanHuos {
  final bool error;
  final List<GanHuo> results;

  GanHuos(this.error, this.results);

  GanHuos.fromJson(Map<String, dynamic> json)
      : error = json['error'],
        results = json['results'];
}

class GanHuo {
  final String _id;
  final String createdAt;
  final String desc;
  final String type;
  final String url;
  final String publishedAt;
  final List<String> images;
  final String who;
  final String source;
  final bool used;

  GanHuo(this._id, this.createdAt, this.desc, this.type, this.url,
      this.publishedAt, this.images, this.who, this.source, this.used);
}
