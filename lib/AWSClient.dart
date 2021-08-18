import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';
import 'package:path/path.dart' as path;

class AWSClient {
  String accessKeyId =
      'AKIA4F7OFCLSB7BXZXPO'; // replace with your own access key
  String secretKeyId =
      '1nWkCWrgk4lKnwqrIjYbv7aFaVC1XmXGUO28Rv+Y'; // replace with your own secret key
  String region = 'us-west-2'; // replace with your account's region name
  String bucketname = 's3imprentatest'; // replace with your S3's bucket name
  String s3Endpoint =
      'https://s3imprentatest.s3-us-west-2.amazonaws.com'; // update the endpoint url for your bucket
  Uint8List data;

  var file; // = File(file).readAsBytesSync();

  /*AWSClient({this.file}) {
    data = File(file).readAsBytesSync();
  }*/
  Future<void> downloadAWS(String fileName) async {
    const _awsUserPoolId = 'us-west-2_xxxxxxxx';
    const _awsClientId = 'xxxxxxxxxxxxxxxxxxxxxxxxxx';

    const _identityPoolId = 'us-west-2:xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx';
    final _userPool = CognitoUserPool(_awsUserPoolId, _awsClientId);

    final _cognitoUser = CognitoUser('+60100000000', _userPool);
    final authDetails =
        AuthenticationDetails(username: '+60100000000', password: 'p@ssW0rd');

    CognitoUserSession _session;
    try {
      _session = await _cognitoUser.authenticateUser(authDetails);
    } catch (e) {
      print(e);
      return;
    }

    final _credentials = CognitoCredentials(_identityPoolId, _userPool);
    await _credentials.getAwsCredentials(_session.getIdToken().getJwtToken());

    final host = 's3.us-west-2.amazonaws.com';
    final region = 'us-west-2';
    final service = 's3';
    final key =
        's3imprentatest/us-west-2:xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/$fileName';
    final payload = SigV4.hashCanonicalRequest('');
    final datetime = SigV4.generateDatetime();
    final canonicalRequest = '''GET
${'/$key'.split('/').map((s) => Uri.encodeComponent(s)).join('/')}

host:$host
x-amz-content-sha256:$payload
x-amz-date:$datetime
x-amz-security-token:${_credentials.sessionToken}

host;x-amz-content-sha256;x-amz-date;x-amz-security-token
$payload''';
    final credentialScope =
        SigV4.buildCredentialScope(datetime, region, service);
    final stringToSign = SigV4.buildStringToSign(datetime, credentialScope,
        SigV4.hashCanonicalRequest(canonicalRequest));
    final signingKey = SigV4.calculateSigningKey(
        _credentials.secretAccessKey, datetime, region, service);
    final signature = SigV4.calculateSignature(signingKey, stringToSign);

    final authorization = [
      'AWS4-HMAC-SHA256 Credential=${_credentials.accessKeyId}/$credentialScope',
      'SignedHeaders=host;x-amz-content-sha256;x-amz-date;x-amz-security-token',
      'Signature=$signature',
    ].join(',');

    final uri = Uri.https(host, key);
    http.Response response;
    try {
      response = await http.get(uri, headers: {
        'Authorization': authorization,
        'x-amz-content-sha256': payload,
        'x-amz-date': datetime,
        'x-amz-security-token': _credentials.sessionToken,
      });
    } catch (e) {
      print(e);
      return;
    }

    final file =
        File(path.join('/Users/danielleguimerans/Downloads', '$fileName'));

    try {
      await file.writeAsBytes(response.bodyBytes);
    } catch (e) {
      print(e.toString());
      return;
    }

    print('complete!');
  }

  dynamic uploadData(String folderName, String fileName, Uint8List data) async {
    final length = data.length;

    final uri = Uri.parse(s3Endpoint);
    final req = http.MultipartRequest("POST", uri);
    final multipartFile = http.MultipartFile(
        'file', http.ByteStream.fromBytes(data), length,
        filename: fileName);

    final policy = Policy.fromS3PresignedPost(
        folderName + '/' + fileName, bucketname, accessKeyId, 15, length,
        region: region);
    final key =
        SigV4.calculateSigningKey(secretKeyId, policy.datetime, region, 's3');
    final signature = SigV4.calculateSignature(key, policy.encode());

    req.files.add(multipartFile);
    req.fields['key'] = policy.key;
    req.fields['acl'] = 'public-read';
    req.fields['X-Amz-Credential'] = policy.credential;
    req.fields['X-Amz-Algorithm'] = 'AWS4-HMAC-SHA256';
    req.fields['X-Amz-Date'] = policy.datetime;
    req.fields['Policy'] = policy.encode();
    req.fields['X-Amz-Signature'] = signature;

    try {
      final res = await req.send();
      await for (var value in res.stream.transform(utf8.decoder)) {
        // print(value);

        return value;
      }
      return res.statusCode.toString();
    } catch (e) {
      print(e.toString());

      return e;
    }
  }
}

class Policy {
  String expiration;
  String region;
  String bucket;
  String key;
  String credential;
  String datetime;
  int maxFileSize;

  Policy(this.key, this.bucket, this.datetime, this.expiration, this.credential,
      this.maxFileSize,
      {this.region = 'us-west-2'});

  factory Policy.fromS3PresignedPost(
    String key,
    String bucket,
    String accessKeyId,
    int expiryMinutes,
    int maxFileSize, {
    String region,
  }) {
    final datetime = SigV4.generateDatetime();
    final expiration = (DateTime.now())
        .add(Duration(minutes: expiryMinutes))
        .toUtc()
        .toString()
        .split(' ')
        .join('T');
    final cred =
        '$accessKeyId/${SigV4.buildCredentialScope(datetime, region, 's3')}';
    final p = Policy(key, bucket, datetime, expiration, cred, maxFileSize,
        region: region);
    return p;
  }

  String encode() {
    final bytes = utf8.encode(toString());
    return base64.encode(bytes);
  }

  @override
  String toString() {
    return '''
{ "expiration": "${this.expiration}",
  "conditions": [
    {"bucket": "${this.bucket}"},
    ["starts-with", "\$key", "${this.key}"],
    {"acl": "public-read"},
    ["content-length-range", 1, ${this.maxFileSize}],
    {"x-amz-credential": "${this.credential}"},
    {"x-amz-algorithm": "AWS4-HMAC-SHA256"},
    {"x-amz-date": "${this.datetime}" }
  ]
}
''';
  }
}
