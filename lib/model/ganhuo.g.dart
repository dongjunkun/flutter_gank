part of 'ganhuo.dart';

GanHuos _$GanHuosFromJson(Map<String, dynamic> json) => GanHuos(
    json['error'] as bool,
    (json['results'] as List)
        ?.map((e) =>
            e == null ? null : GanHuo.formJson(e as Map<String, dynamic>))
        ?.toList());

abstract class _GanHuosSerializerMiXin {
  bool get error;

  List<GanHuo> get results;

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'error': error, 'results': results};
}

GanHuo _$GanHuoFormJson(Map<String, dynamic> json) => GanHuo(
    json['_id'] as String,
    json['createAt'] as String,
    json['desc'] as String,
    json['type'] as String,
    json['url'] as String,
    json['publishedAt'] as String,
    (json['images'] as List)
        ?.map((e) => e as String)?.toList(),
    json['who'] as String,
    json['source'] as String,
    json['used'] as bool);

abstract class _$GanHuoSerializerMiXin {
  String get _id;

  String get createdAt;

  String get desc;

  String get type;

  String get url;

  String get publishedAt;

  List<String> get images;

  String get who;

  String get source;

  bool get used;

  Map<String, dynamic> toJson() => <String, dynamic>{
        '_id': _id,
        'createdAt': createdAt,
        'desc': desc,
        'type': type,
        'url': url,
        'publishedAt': publishedAt,
        'images': images,
        'who': who,
        'source': source,
        'used': used
      };
}
