// AI 名单导入服务：调用 OpenAI 兼容接口（默认 DeepSeek）从文本或图片提取学生名单
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../configs/strings.dart';

/// AI 识别出的单个学生（预览阶段可编辑）
class AiStudent {
  AiStudent({required this.studentName, required this.studentNumber});

  String studentName;
  String studentNumber;
  bool selected = true;
}

class AiImportException implements Exception {
  AiImportException(this.message);
  final String message;

  @override
  String toString() => message;
}

class AiImportService {
  AiImportService._();

  static const String _extractPrompt =
      '你是课堂点名助手的名单提取器。从用户提供的名单文本或图片中提取所有学生，'
      '只输出一个严格的 JSON 数组，不要输出任何解释、markdown 代码块或其他内容。'
      '数组每个元素形如 {"studentName":"姓名","studentNumber":"学号"}。'
      '要求：学号缺失时 studentNumber 用 null；保持原有顺序；'
      '忽略表头、序号列、性别、班级、备注等无关信息；去除重复学生；'
      '姓名去掉空格与标点，规整为纯汉字。';

  static const List<String> _presetModels = [
    'deepseek-flash',
    'deepseek-v4-flash',
    'deepseek-v4-pro',
  ];

  static List<String> get presetModels => _presetModels;

  /// 读取 AI 配置；未配置 key 时抛出 AiImportException
  static Future<({String baseUrl, String apiKey, String model})> loadConfig() async {
    final storage = await SharedPreferences.getInstance();
    final apiKey = storage.getString(KString.aiApiKeyKey)?.trim() ?? '';
    if (apiKey.isEmpty) {
      throw AiImportException('NO_CONFIG');
    }
    return (
      baseUrl: (storage.getString(KString.aiBaseUrlKey)?.trim().isNotEmpty ?? false)
          ? storage.getString(KString.aiBaseUrlKey)!.trim()
          : KString.aiDefaultBaseUrl,
      apiKey: apiKey,
      model: (storage.getString(KString.aiModelKey)?.trim().isNotEmpty ?? false)
          ? storage.getString(KString.aiModelKey)!.trim()
          : KString.aiDefaultModel,
    );
  }

  /// 识别名单。[text] 与 [base64Image] 至少提供一个；图片为未加前缀的 base64
  static Future<List<AiStudent>> recognize({String? text, String? base64Image}) async {
    final config = await loadConfig();

    final Object content;
    if (base64Image != null && base64Image.isNotEmpty) {
      content = [
        {'type': 'text', 'text': _extractPrompt},
        {
          'type': 'image_url',
          'image_url': {'url': 'data:image/jpeg;base64,$base64Image'},
        },
      ];
    } else {
      final trimmed = text?.trim() ?? '';
      if (trimmed.isEmpty) {
        throw AiImportException('EMPTY_INPUT');
      }
      content = '$_extractPrompt\n\n名单内容：\n$trimmed';
    }

    final dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 120),
      sendTimeout: const Duration(seconds: 60),
    ));

    final Response<dynamic> resp;
    try {
      resp = await dio.post(
        _chatCompletionsUrl(config.baseUrl),
        options: Options(headers: {
          'Authorization': 'Bearer ${config.apiKey}',
          'Content-Type': 'application/json',
        }),
        data: {
          'model': config.model,
          'messages': [
            {'role': 'user', 'content': content},
          ],
          'temperature': 0,
          'stream': false,
        },
      );
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      final body = e.response?.data;
      String detail = '';
      if (body is Map && body['error'] is Map) {
        detail = (body['error']['message'] ?? '').toString();
      } else if (body is String && body.isNotEmpty) {
        detail = body;
      }
      if (code == 401) {
        throw AiImportException('AUTH_FAILED');
      }
      throw AiImportException('HTTP_${code ?? '???'} ${detail.isNotEmpty ? detail : e.message ?? ''}');
    }

    final String answer;
    try {
      answer = ((resp.data['choices'] as List).first['message']['content'] ?? '')
          .toString();
    } catch (_) {
      throw AiImportException('BAD_RESPONSE');
    }

    return _parseStudents(answer);
  }

  /// 拉取 /models 模型列表（OpenAI 兼容），供设置页一键选用
  static Future<List<String>> listModels() async {
    final config = await loadConfig();
    final dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
    ));
    final Response<dynamic> resp;
    try {
      resp = await dio.get(
        _chatCompletionsUrl(config.baseUrl).replaceFirst(
          '/chat/completions',
          '/models',
        ),
        options: Options(headers: {
          'Authorization': 'Bearer ${config.apiKey}',
        }),
      );
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      if (code == 401) throw AiImportException('AUTH_FAILED');
      final body = e.response?.data;
      String detail = '';
      if (body is Map && body['error'] is Map) {
        detail = (body['error']['message'] ?? '').toString();
      }
      throw AiImportException(
          'HTTP_${code ?? '???'} ${detail.isNotEmpty ? detail : e.message ?? ''}');
    }
    final data = resp.data['data'];
    if (data is! List) throw AiImportException('BAD_RESPONSE');
    final ids = data
        .whereType<Map>()
        .map((m) => (m['id'] ?? '').toString())
        .where((s) => s.isNotEmpty)
        .toList()
      ..sort();
    return ids;
  }

  /// 拼接 chat/completions 地址，兼容 base_url 带/不带 /v1 的写法
  static String _chatCompletionsUrl(String baseUrl) {
    var url = baseUrl.trim();
    while (url.endsWith('/')) {
      url = url.substring(0, url.length - 1);
    }
    if (url.endsWith('/chat/completions')) return url;
    if (url.endsWith('/v1')) return '$url/chat/completions';
    return '$url/v1/chat/completions';
  }

  /// 从模型回答中容错提取学生数组
  static List<AiStudent> _parseStudents(String answer) {
    var raw = answer.trim();
    // 去掉 markdown 代码块围栏
    final fence = RegExp(r'```(?:json)?\s*([\s\S]*?)```');
    final m = fence.firstMatch(raw);
    if (m != null) {
      raw = m.group(1)!.trim();
    }
    final start = raw.indexOf('[');
    final end = raw.lastIndexOf(']');
    if (start < 0 || end <= start) {
      throw AiImportException('NO_JSON');
    }
    raw = raw.substring(start, end + 1);

    List<dynamic> list;
    try {
      list = jsonDecode(raw) as List<dynamic>;
    } catch (_) {
      throw AiImportException('JSON_PARSE');
    }

    final students = <AiStudent>[];
    final seen = <String>{};
    for (final item in list) {
      if (item is! Map) continue;
      final name = _firstOf(item, ['studentName', 'name', '姓名', 'student_name']);
      if (name == null || name.trim().isEmpty) continue;
      final number = _firstOf(
          item, ['studentNumber', 'number', 'id', '学号', 'student_number', 'no']);
      final key = '${name.trim()}|${number?.trim() ?? ''}';
      if (seen.contains(key)) continue;
      seen.add(key);
      students.add(AiStudent(
        studentName: name.trim(),
        studentNumber: (number ?? '').trim(),
      ));
    }
    return students;
  }

  static String? _firstOf(Map<dynamic, dynamic> map, List<String> keys) {
    for (final k in keys) {
      final v = map[k];
      if (v == null) continue;
      final s = v.toString().trim();
      if (s.isNotEmpty && s.toLowerCase() != 'null') return s;
    }
    return null;
  }
}
