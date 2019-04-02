import 'package:http/http.dart' as http;

class Api {
  Api();

  String apiUrl = 'http://192.168.43.142:3000';

  Future doRegister(String cid, String pincode, String telephone) async {
    // localhost:3000/user/save - POST : pincode, cid, telephone, emi
    String _url = '$apiUrl/user/save';

    var body = {
      "cid": cid.toString(),
      "pincode": pincode.toString(),
      "telephone": telephone.toString()
    };

    return await http.post(_url, body: body);
  }
}
