import 'dart:io';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:convert' as convert;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String currency = 'USD';
  String valueOfBTC = '', valueOfETH = '', valueOfLTC = '';
  bool isloading = false;

  void getRateValue(String currencyValue) async {
    String url =
        'https://rest.coinapi.io/v1/exchangerate/BTC/$currencyValue?apikey=890F11EF-922C-4A4E-A67F-7C8A86C40165';
    var response = await http.get(url);
    var data = convert.jsonDecode(response.body);
    double temp = data['rate'];
    valueOfBTC = temp.toStringAsFixed(2);
    url =
        'https://rest.coinapi.io/v1/exchangerate/ETH/$currencyValue?apikey=890F11EF-922C-4A4E-A67F-7C8A86C40165';
    response = await http.get(url);
    data = convert.jsonDecode(response.body);
    temp = data['rate'];
    valueOfETH = temp.toStringAsFixed(2);
    url =
        'https://rest.coinapi.io/v1/exchangerate/LTC/$currencyValue?apikey=890F11EF-922C-4A4E-A67F-7C8A86C40165';
    response = await http.get(url);
    data = convert.jsonDecode(response.body);
    temp = data['rate'];
    valueOfLTC = temp.toStringAsFixed(2);
    setState(() {
      isloading = false;
      currency = currencyValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
                child: CustomCurrencyDataWidget(
                  isloading: isloading,
                  currency: currency,
                  currencyRate: valueOfBTC,
                  convertValue: 'BTC',
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
                child: CustomCurrencyDataWidget(
                  isloading: isloading,
                  currency: currency,
                  currencyRate: valueOfETH,
                  convertValue: 'ETH',
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
                child: CustomCurrencyDataWidget(
                  isloading: isloading,
                  currency: currency,
                  currencyRate: valueOfLTC,
                  convertValue: 'LTC',
                ),
              ),
            ],
          ),
          Container(
              height: 150.0,
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 30.0),
              color: Colors.lightBlue,
              child: Platform.isIOS
                  ? CupertinoPicker(
                      itemExtent: 35,
                      onSelectedItemChanged: (selectedIndes) {},
                      children: currenciesList.map((e) => Text(e)).toList(),
                    )
                  : DropdownButton<String>(
                      value: currency,
                      items: currenciesList
                          .map(
                            (e) => DropdownMenuItem(
                              child: Text(e),
                              value: e,
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          isloading = true;
                          getRateValue(value);
                        });
                      },
                    )),
        ],
      ),
    );
  }
}

class CustomCurrencyDataWidget extends StatelessWidget {
  const CustomCurrencyDataWidget({
    Key key,
    @required this.isloading,
    @required this.currency,
    @required this.currencyRate,
    @required this.convertValue,
  }) : super(key: key);

  final bool isloading;
  final String currency, currencyRate, convertValue;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.lightBlueAccent,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
        child: isloading
            ? Center(
                child: SpinKitRing(
                  color: Colors.white,
                ),
              )
            : Text(
                '1 $convertValue = $currencyRate $currency',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
