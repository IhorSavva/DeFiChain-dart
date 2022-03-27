import 'package:test/test.dart';
import 'package:defichaindart/src/address.dart' show Address;
import 'package:defichaindart/src/models/networks.dart' as networks;

void main() {
  group('Address', () {
    group('validateAddress', () {
      test('base58 addresses and valid network', () {
        expect(Address.validateAddress('mhv6wtF2xzEqMNd3TbXx9TjLLo6mp2MUuT', networks.testnet), true);
        expect(Address.validateAddress('1K6kARGhcX9nJpJeirgcYdGAgUsXD59nHZ'), true);
      });
      test('base58 addresses and invalid network', () {
        expect(Address.validateAddress('mhv6wtF2xzEqMNd3TbXx9TjLLo6mp2MUuT', networks.bitcoin), false);
        expect(Address.validateAddress('1K6kARGhcX9nJpJeirgcYdGAgUsXD59nHZ', networks.testnet), false);
      });
      test('bech32 addresses and valid network', () {
        expect(Address.validateAddress('tb1qgmp0h7lvexdxx9y05pmdukx09xcteu9sx2h4ya', networks.testnet), true);
        expect(Address.validateAddress('bc1qw508d6qejxtdg4y5r3zarvary0c5xw7kv8f3t4'), true);
        expect(Address.validateAddress('bc1qtzvkdl38k5m3czc3a43yqg8nc8k9ly0yav5l7r'), true);
      });
      test('bech32 addresses and invalid network', () {
        expect(Address.validateAddress('tb1qgmp0h7lvexdxx9y05pmdukx09xcteu9sx2h4ya'), false);
        expect(Address.validateAddress('bc1qw508d6qejxtdg4y5r3zarvary0c5xw7kv8f3t4', networks.testnet), false);
      });
      test('invalid addresses', () {
        expect(Address.validateAddress('3333333casca'), false);
      });
    });
  });
}
