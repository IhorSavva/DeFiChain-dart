import 'dart:typed_data';
import 'models/networks.dart';
import 'package:bs58check/bs58check.dart' as bs58check;
import 'package:bech32/bech32.dart';
import 'payments/index.dart' show PaymentData;
import 'payments/p2pkh.dart';
import 'payments/p2sh.dart';
import 'payments/p2wpkh.dart';

class Address {
  static bool validateAddress(String address, [NetworkType nw]) {
    try {
      addressToOutputScript(address, nw);
      return true;
    } catch (err) {
      return false;
    }
  }

  static Uint8List addressToOutputScript(String address, [NetworkType nw]) {
    NetworkType network = nw ?? bitcoin;
    var decodeBase58;
    var decodeBech32;
    try {
      decodeBase58 = bs58check.decode(address);
    } catch (err) {
      // Base58check decode fail
    }
    if (decodeBase58 != null) {
      if (decodeBase58[0] == network.pubKeyHash) {
        return P2PKH(data: new PaymentData(address: address), network: network)
            .data
            .output;
      }
      if (decodeBase58[0] == network.scriptHash) {
        return P2SH(data: new PaymentData(address: address), network: network)
            .data
            .output;
      }
      throw new ArgumentError('Invalid version or Network mismatch');
    } else {
      try {
        decodeBech32 = segwit.decode(address);
      } catch (err) {
        // Bech32 decode fail
      }
      if (decodeBech32 != null) {
        if (network.bech32 != decodeBech32.hrp)
          throw new ArgumentError('Invalid prefix or Network mismatch');
        if (decodeBech32.version != 0)
          throw new ArgumentError('Invalid address version');
        P2WPKH p2wpkh = new P2WPKH(
            data: new PaymentData(address: address), network: network);
        return p2wpkh.data.output;
      }
    }
    throw new ArgumentError(address + ' has no matching Script');
  }
}
