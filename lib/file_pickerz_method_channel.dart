import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'file_pickerz.dart';
import 'file_pickerz_platform_interface.dart';

class MethodChannelFilePickerz extends FilePickerzPlatform {

  @visibleForTesting
  final methodChannel = const MethodChannel('flutter.plugins.filepicker');

  @visibleForTesting
  final eventChannel = const EventChannel('flutter.plugins.filepickerevent');

  static const String _tag = 'MethodChannelFilePicker';

  static StreamSubscription? _eventSubscription;

  @override
  Future<FilePickerResult?> pickFiles(
          FileType type,
          List<String>? allowedExtensions,
          String? dialogTitle,
          String? initialDirectory,
          Function(FilePickerStatus p1)? onFileLoading,
          bool? allowCompression,
          bool allowMultiple,
          bool? withData,
          bool? withReadStream,
          bool lockParentWindow) =>
      _getPath(
        type,
        allowMultiple,
        allowCompression,
        allowedExtensions,
        onFileLoading,
        withData,
        withReadStream,
      );

  @override
  Future<bool?> clearTemporaryFiles() async =>
      methodChannel.invokeMethod<bool>('clear');


  @override
  Future<String?> getDirectoryPath(String dialogTitle, bool lockParentWindow, String initialDirectory) async {
    try {
      return await methodChannel.invokeMethod('dir', {});
    } on PlatformException catch (ex) {
      if (ex.code == "unknown_path") {
        debugPrint(
            '[$_tag] Could not resolve directory path. Maybe it\'s a protected one or unsupported (such as Downloads folder). If you are on Android, make sure that you are on SDK 21 or above.');
      }
    }
    return null;
  }

  Future<FilePickerResult?> _getPath(
    FileType fileType,
    bool allowMultipleSelection,
    bool? allowCompression,
    List<String>? allowedExtensions,
    Function(FilePickerStatus)? onFileLoading,
    bool? withData,
    bool? withReadStream,
  ) async {
    {
      final String type = describeEnum(fileType);
      if (type != 'custom' && (allowedExtensions?.isNotEmpty ?? false)) {
        throw Exception(
            'You are setting a type [$fileType]. Custom extension filters are only allowed with FileType.custom, please change it or remove filters.');
      }
      try {
        _eventSubscription?.cancel();
        if (onFileLoading != null) {
          _eventSubscription = eventChannel.receiveBroadcastStream().listen(
                (data) => onFileLoading((data as bool)
                    ? FilePickerStatus.picking
                    : FilePickerStatus.done),
                onError: (error) => throw Exception(error),
              );
        }

        final List<Map>? result = await methodChannel.invokeListMethod(type, {
          'allowMultipleSelection': allowMultipleSelection,
          'allowedExtensions': allowedExtensions,
          'allowCompression': allowCompression,
          'withData': withData,
        });

        if (result == null) {
          return null;
        }

        final List<PlatformFile> platformFiles = <PlatformFile>[];

        for (final Map platformFileMap in result) {
          platformFiles.add(
            PlatformFile.fromMap(
              platformFileMap,
              readStream: withReadStream!
                  ? File(platformFileMap['path']).openRead()
                  : null,
            ),
          );
        }

        return FilePickerResult(platformFiles);
      } on PlatformException catch (e) {
        debugPrint('[$_tag] Platform exception: $e');
        rethrow;
      } catch (e) {
        debugPrint(
            '[$_tag] Unsupported operation. Method not found. The exception thrown was: $e');
        rethrow;
      }
    }
  }
}
