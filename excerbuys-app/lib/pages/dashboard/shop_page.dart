import 'package:dio/dio.dart';
import 'package:excerbuys/utils/fetching/utils.dart';
import 'package:excerbuys/wrappers/ripple_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:payu/payu.dart';

String apiBaseUrl(Environment environment) {
  switch (environment) {
    case Environment.production:
      return 'https://secure.payu.com/';
    case Environment.sandbox:
      return 'https://secure.snd.payu.com/';
    case Environment.sandboxBeta:
      return 'https://secure.sndbeta.payu.com/';
  }
}

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  @override
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 200),
      child: RippleWrapper(
          child: Text('auth'),
          onPressed: () async {
            try {
              final res = await dio.post(
                  '${apiBaseUrl(Environment.sandbox)}pl/standard/user/oauth/authorize',
                  data: {
                    "client_id": "488445",
                    "client_secret": "0d8583a49383cb3f2c473bf19af302e5",
                    "grant_type": "client_credentials",
                  },
                  options: Options(headers: {
                    "Content-Type": "application/x-www-form-urlencoded"
                  }));
              print(res);
            } catch (err) {
              print(err);
            }
          }),
    );
  }
}
