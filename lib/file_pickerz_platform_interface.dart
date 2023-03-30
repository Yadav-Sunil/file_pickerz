import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'file_pickerz_method_channel.dart';
import 'src/file_picker_result.dart';

enum FileType {
  any,
  media,
  image,
  video,
  audio,
  custom,
}

enum FilePickerStatus {
  picking,
  done,
}

abstract class FilePickerzPlatform extends PlatformInterface {
  /// Constructs a FilePickerzPlatform.
  FilePickerzPlatform() : super(token: _token);

  static final Object _token = Object();

  static FilePickerzPlatform _instance = MethodChannelFilePickerz();

  /// The default instance of [FilePickerzPlatform] to use.
  ///
  /// Defaults to [MethodChannelFilePickerz].
  static FilePickerzPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FilePickerzPlatform] when
  /// they register themselves.
  static set instance(FilePickerzPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<FilePickerResult?> pickFiles(
    FileType type,
    List<String>? allowedExtensions,
    String? dialogTitle,
    String? initialDirectory,
    Function(FilePickerStatus)? onFileLoading,
    bool? allowCompression,
    bool allowMultiple,
    bool? withData,
    bool? withReadStream,
    bool lockParentWindow,
  ) {
    throw UnimplementedError('pickFiles() has not been implemented.');
  }

  clearTemporaryFiles() {}

  Future<String?> getDirectoryPath(String dialogTitle, bool lockParentWindow, String initialDirectory);
}
