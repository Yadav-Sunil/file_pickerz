import '../file_pickerz_platform_interface.dart';
import 'file_picker_result.dart';
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

class FilePickerz {

  Future<FilePickerResult?> pickFiles({
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    String? dialogTitle,
    String? initialDirectory,
    Function(FilePickerStatus)? onFileLoading,
    bool? allowCompression = true,
    bool allowMultiple = false,
    bool? withData = false,
    bool? withReadStream = false,
    bool lockParentWindow = false,
  }) {
    return FilePickerzPlatform.instance.pickFiles(
        type,
        allowedExtensions,
        dialogTitle,
        initialDirectory,
        onFileLoading,
        allowCompression,
        allowMultiple,
        withData,
        withReadStream,
        lockParentWindow);
  }

  clearTemporaryFiles() {
    return FilePickerzPlatform.instance.clearTemporaryFiles();
  }

  Future<String?> getDirectoryPath({
    String? dialogTitle,
    bool lockParentWindow = false,
    String? initialDirectory,
  }) {
    return FilePickerzPlatform.instance.getDirectoryPath(
      dialogTitle??"",
      lockParentWindow,
      initialDirectory??"",
    );
  }
}
