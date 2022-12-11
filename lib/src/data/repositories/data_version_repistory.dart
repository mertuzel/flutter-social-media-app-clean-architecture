import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:friend_zone/src/domain/repositories/version_repository.dart';
import 'package:friend_zone/src/domain/types/enum_version_status.dart';
import 'package:hive/hive.dart';

// import 'package:graphql_flutter/graphql_flutter.dart' as graphQL;

class DataVersionRepository implements VersionRepository {
  static DataVersionRepository? _instance;
  DataVersionRepository._();
  factory DataVersionRepository() {
    _instance ??= DataVersionRepository._();

    return _instance!;
  }

  @override
  void killInstance() {
    _instance = null;
  }

  @override
  Future<VersionStatus> get versionStatus async {
    try {
      final connectivityResult = await (Connectivity().checkConnectivity());

      if (connectivityResult == ConnectivityResult.none) {
        return VersionStatus.NO_INTERNET_CONNECTION;
      } else {
        try {
          final result = await InternetAddress.lookup('google.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            print('connected');
          }
        } on SocketException catch (_) {
          print('not connected');
          return VersionStatus.NO_INTERNET_CONNECTION;
        }
        return VersionStatus.READY_TO_GO;
      }
    } catch (e, st) {
      print(e);
      print(st);
      rethrow;
    }
  }
}
