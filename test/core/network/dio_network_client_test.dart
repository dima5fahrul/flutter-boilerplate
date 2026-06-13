import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_boilerplate/core/network/dio_network_client.dart';

void main() {
  group('buildDio', () {
    test('adds AuthInterceptor by default', () {
      final dio = buildDio();
      expect(dio.interceptors.any((i) => i is AuthInterceptor), isTrue);
    });

    test('adds extra interceptors when provided', () {
      final chucker = ChuckerDioInterceptor();
      final dio = buildDio(extraInterceptors: [chucker]);
      expect(dio.interceptors.contains(chucker), isTrue);
    });

    test('extra interceptors added after AuthInterceptor', () {
      final chucker = ChuckerDioInterceptor();
      final dio = buildDio(extraInterceptors: [chucker]);
      final list = dio.interceptors.toList();
      final authIdx = list.indexWhere((i) => i is AuthInterceptor);
      final chuckerIdx = list.indexOf(chucker);
      expect(chuckerIdx, greaterThan(authIdx));
    });

    test('no extra interceptors when list is empty', () {
      final dio = buildDio();
      final chucker = ChuckerDioInterceptor();
      final dioWithChucker = buildDio(extraInterceptors: [chucker]);
      expect(dioWithChucker.interceptors.length, greaterThan(dio.interceptors.length));
    });
  });
}
