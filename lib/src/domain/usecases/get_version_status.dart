import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/domain/repositories/version_repository.dart';
import 'package:friend_zone/src/domain/types/enum_version_status.dart';

class GetVersionStatus extends UseCase<VersionStatus, void> {
  final VersionRepository _versionRepository;

  GetVersionStatus(this._versionRepository);

  @override
  Future<Stream<VersionStatus>> buildUseCaseStream(void params) async {
    StreamController<VersionStatus> controller = StreamController();
    try {
      VersionStatus status = await _versionRepository.versionStatus;
      controller.add(status);
      controller.close();
    } catch (error, stackTrace) {
      controller.addError(error, stackTrace);
    }
    return controller.stream;
  }
}
