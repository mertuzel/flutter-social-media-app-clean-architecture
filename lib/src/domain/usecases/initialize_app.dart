import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:friend_zone/src/data/repositories/data_authentication_repository.dart';
import 'package:friend_zone/src/data/repositories/data_chat_repository.dart';
import 'package:friend_zone/src/data/repositories/data_post_repository.dart';
import 'package:friend_zone/src/data/repositories/data_story_repository.dart';
import 'package:friend_zone/src/data/repositories/data_user_repository.dart';
import 'package:friend_zone/src/data/repositories/data_version_repistory.dart';
import 'package:friend_zone/src/domain/repositories/authentication_repository.dart';
import 'package:friend_zone/src/domain/repositories/chat_repository.dart';
import 'package:friend_zone/src/domain/repositories/post_repository.dart';
import 'package:friend_zone/src/domain/repositories/story_repository.dart';
import 'package:friend_zone/src/domain/repositories/user_repository.dart';
import 'package:friend_zone/src/domain/repositories/version_repository.dart';

class InitializeApp extends UseCase<void, void> {
  AuthenticationRepository _authenticationRepository;
  PostRepository _postRepository;
  StoryRepository _storyRepository;
  UserRepository _userRepository;
  VersionRepository _versionRepository;
  ChatRepository _chatRepository;

  InitializeApp(
    this._authenticationRepository,
    this._postRepository,
    this._storyRepository,
    this._userRepository,
    this._versionRepository,
    this._chatRepository,
  );

  @override
  Future<Stream<void>> buildUseCaseStream(void params) async {
    StreamController<void> controller = StreamController();
    try {
      // Singleton instance reset after signOut and signIns
      _authenticationRepository.killInstance();
      _postRepository.killInstance();
      _storyRepository.killInstance();
      _userRepository.killInstance();
      _versionRepository.killInstance();
      _chatRepository.killInstance();

      // Hive.box('temporaryBox').clear();
      // Ends Here

      // To create instances again and set them.
      // Not the best way to do it.
      _authenticationRepository = DataAuthenticationRepository();
      _postRepository = DataPostRepository();
      _storyRepository = DataStoryRepository();
      _userRepository = DataUserRepository();
      _versionRepository = DataVersionRepository();
      _chatRepository = DataChatRepository();

      await _userRepository.initializeRepository();
      FirebaseAuth.instance.currentUser!.uid;

      controller.close();
    } catch (error, stackTrace) {
      controller.addError(error, stackTrace);
    }
    return controller.stream;
  }
}
