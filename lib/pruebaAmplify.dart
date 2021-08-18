// Amplify Flutter Packages
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';

import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<void> createAndUploadFile() async {
  // Add this line, to include Auth and Storage plugins.
  await Amplify.addPlugins([AmplifyAuthCognito(), AmplifyStorageS3()]);
// ... add other plugins, if any
//await Amplify.configure(amplifyconfig);
  // Create a dummy file
  final exampleString = 'Example file contents';
  final tempDir = await getTemporaryDirectory();
  final exampleFile = File(tempDir.path + '/example.txt')
    ..createSync()
    ..writeAsStringSync(exampleString);

  // Upload the file to S3
  try {
    final UploadFileResult result = await Amplify.Storage.uploadFile(
      local: exampleFile,
      key: 'ExampleKey',
    );
    print('Successfully uploaded file: ${result.key}');
  } on StorageException catch (e) {
    print('Error uploading file: $e');
  }
}
