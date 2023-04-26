import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'ACCESSKEY', obfuscate: true)
  static final accessKey = _Env.accessKey;
  @EnviedField(varName: 'SECRETKEY', obfuscate: true)
  static final secretKey = _Env.secretKey;
}
