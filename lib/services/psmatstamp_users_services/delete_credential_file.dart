import 'package:psm_at_stamp/services/file_system_manager_services/delete_file.dart';

Future<void> deleteCredentialFile() async {
  try {
    await deleteFile(fileName: "credential.json");
  } catch (e) {
    throw e;
  }
}
