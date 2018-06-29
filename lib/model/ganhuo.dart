part 'package:gank_app/model/ganhuo.g.dart';

class GanHuos extends Object with _GanHuosSerializerMiXin{
  final bool error;
  final List<GanHuo> results;

  GanHuos(this.error, this.results);

  factory GanHuos.fromJson(Map<String, dynamic> json)
     => _$GanHuosFromJson(json);

}

class GanHuo extends Object with _$GanHuoSerializerMiXin {
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

  factory GanHuo.formJson(Map<String, dynamic> json) => _$GanHuoFormJson(json);
}
