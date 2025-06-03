import 'package:goevent2/Api/Config.dart';
import 'package:googleapis_auth/auth_io.dart';

class FirebaseAccesstoken {
  static String firebaseMessageScope = "https://www.googleapis.com/auth/firebase.messaging";

  Future<String> getAccessToken() async {
    final credentials = ServiceAccountCredentials.fromJson({
      "type": "service_account",
      "project_id": "redbus-3ec46",
      "private_key_id": "b1a115fb041ddb15652e249e59bbe31d9094bff6",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDACty9CYH/kG37\nzCDAmH3PxShas/msL56bnZ8/A3QHqU6VDgJYIxHoZOyPlwJ02fHQ1m4azKG3IjmK\nDb6HDcptTRoPjMjIPqGEB3nbTz82SWT1CoKqmMVF3N8R+S1HLLvkm5pW3LT3NCDq\n5S0NmG6lFcqXZPEH2gwWO01daNzoPB9TyxCAfFBUFdhZMCvtBw0jRrT5AoQTZv4e\nigxagk2Jkstk1pag5noHt2cFsxb1d7X5Y4Bze8OILD+pBPxvyp8ggBvuOIJPF8qk\nvwVG1p8uny3j/jDQ51LUsajPGqrcOxPsibrDkHfEgTkMg4nctZu9ENBKKEYSroN9\nqmrkhRurAgMBAAECggEAOBIz1yHyieriofU8zt73RPW8zZbk3ChfN/Jyr5RTiXUe\nk5iuiItczCzDgT1HI1ULLL2fEkYTJYRhpnRS393f77/mTwn9CbJ3uDPymVzvCOuv\nBXjXI/ZNCxPtMbM+TBy8k4f3LUttrwvSXKMjX2fVTnApYcDAO1mn08nm0dIvRcLd\nyeBvBYRxVX0eG6Ckkm5ehBDsRnj7RUBGV3Omu1qIe+Br9BX5YxsgTfBH5m4X1nxI\ncrwMmn/XYz2Q229Kg8ghN/uak+odV6kpKC6KpPQRk1G7xDl6iiLboDACQOu+DxHN\nodlh94JB1OtkA5Gm23XcNysjMcvQSFfy8jRzYLdsGQKBgQDFSEIJbMIXpSI3nyx3\nGkjzI4M+7m0OCOHTw1RlIl9XAyHzAVU8oKlupgTdk68P0XJiR6CzTJXzEbyMfQOG\nqb3ZqJIPT2xdOx2cagdBsR8OXsKCbTvB0CKho59pUcxpJEvPIni6aks7DG7iDUGz\nT4RNdV9xlQ7i1a5LX8T6X+EHRwKBgQD5M1xHCnoBiaH06/XREIMyONFG0qhhxPUY\nsz20ZayCxI8cKHP3c/F9aCNY/eqGT2f0femAT6gL9M+6+LygsPhNU7CG4XDD8Fff\noBd6Hb3LBGVN9hSikcKzsWCPggqx5pnj61or6TVFnQs5Kc5BIzX+HWzQId4Gj/xB\nWJHQuLoCfQKBgQC6nSxiT++VgE5KwRXFoCaLX/dhixW7pelAcE+fzxDSdRMjFAq1\n69/5269UjcOWOfBySQEZOgPJxuhNGGBCfMQqZQus0dtWoXnUIHO2zz3qUPa7e2qA\nXkq0DdvYO1kZyAyx5hC/fZamR4+H4zRX0or63mEnRvGq3qgdgn0IvbNWNwKBgQDc\nmjr2KLAY7F4TE09o49VAgEvDBnlJE7JlS0c0i01L9fU6WBVQ2bLN8YJZJW6Xt3Ov\nXEd47ws0imPagJd7KS6mRY/f13KcAgfIT1B5Khr5vcpwWYeq4p4ZtMxmPhh5pEpX\nGeGZPbmLBpsI35lW0HTbn/DTzyddZ9lHf8CVpPIFgQKBgB2apAwoZnE9W1t1b4d4\nFVh4vOWseDr6GjqEYEajL0Xhm9AQpUahIAxcu1v4YGwE/ON5/7xJ9nyD3jdPvwFl\n5igFHXLs1jt1NzbRYNMfXp/Xsd1xq0bvtyvPCnSsje0j87FN+cqW1rvnIoJZGKok\neInvc7FP1KiQyBAfHw5/ONyo\n-----END PRIVATE KEY-----\n",
      "client_email": "firebase-adminsdk-1fgos@redbus-3ec46.iam.gserviceaccount.com",
      "client_id": "104380614981963443179",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-1fgos%40redbus-3ec46.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    });

    final client = await clientViaServiceAccount(credentials, [firebaseMessageScope]);

    final accessToken = client.credentials.accessToken.data;
    Config.firebaseKey = accessToken;
    print("+++++++++++++++++:---- ${Config.firebaseKey}");
    return accessToken;
  }

}