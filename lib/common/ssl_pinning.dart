import 'dart:io';

import 'package:flutter/services.dart';

class SslPinningHttpClient {
  /*certificates/developer.themoviedb.org.pem*/

  Future<SecurityContext> createContext() async {
    final sslCert = await rootBundle.load('certificates/tmdb_api_cert.pem');
    SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
    securityContext.setTrustedCertificatesBytes(sslCert.buffer.asInt8List());
    return securityContext;
  }
}
