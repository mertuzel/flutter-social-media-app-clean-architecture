import 'package:friend_zone/src/domain/types/enum_version_status.dart';

abstract class VersionRepository {
  void killInstance();
  Future<VersionStatus> get versionStatus;
}
