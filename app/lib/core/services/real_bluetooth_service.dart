import 'dart:async';
import 'dart:convert';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../models/oxyfeeder_status.dart';
import 'bluetooth_service_interface.dart';

/// Real Bluetooth service that connects to the physical OxyFeeder hardware
///
/// This service:
/// 1. Scans for the "OxyFeeder" BLE device
/// 2. Connects to it
/// 3. Subscribes to the characteristic that broadcasts JSON data
/// 4. Parses JSON and emits OxyFeederStatus objects via statusStream
class RealBluetoothService implements BluetoothServiceInterface {
  // BLE UUIDs from ESP32 firmware
  static const String serviceUuid = '0000abcd-0000-1000-8000-00805f9b34fb';
  static const String characteristicUuid = '0000abce-0000-1000-8000-00805f9b34fb';

  // Stream controller for status updates
  final StreamController<OxyFeederStatus> _statusStreamController =
      StreamController<OxyFeederStatus>.broadcast();

  /// Stream of OxyFeederStatus objects from the hardware
  @override
  Stream<OxyFeederStatus> get statusStream => _statusStreamController.stream;

  // Connection state
  BluetoothDevice? _connectedDevice;
  BluetoothCharacteristic? _dataCharacteristic;
  StreamSubscription<List<int>>? _characteristicSubscription;
  StreamSubscription<BluetoothConnectionState>? _connectionStateSubscription;

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  // Scan subscription
  StreamSubscription<List<ScanResult>>? _scanSubscription;

  /// Connect to the OxyFeeder device
  ///
  /// This method:
  /// 1. Scans for devices named "OxyFeeder"
  /// 2. Connects to the first one found
  /// 3. Discovers services and characteristics
  /// 4. Subscribes to data notifications
  Future<void> connect() async {
    try {
      // Check if Bluetooth is supported and enabled
      if (!(await FlutterBluePlus.isSupported)) {
        throw Exception('Bluetooth not available on this device');
      }

      var adapterState = await FlutterBluePlus.adapterState.first;
      if (adapterState != BluetoothAdapterState.on) {
        throw Exception('Bluetooth is turned off. Please enable Bluetooth.');
      }

      // Start scanning for devices
      print('RealBluetoothService: Starting scan for OxyFeeder...');
      await FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 10),
      );

      // Listen for scan results
      _scanSubscription = FlutterBluePlus.scanResults.listen((results) async {
        for (ScanResult result in results) {
          // Look for device named "OxyFeeder"
          if (result.device.platformName == 'OxyFeeder') {
            print('RealBluetoothService: Found OxyFeeder device: ${result.device.remoteId}');

            // Stop scanning once found
            FlutterBluePlus.stopScan();

            // Connect to the device
            await _connectToDevice(result.device);
            break;
          }
        }
      });

      // Wait for scan to complete
      await Future.delayed(const Duration(seconds: 11));

      if (!_isConnected) {
        throw Exception('Could not find OxyFeeder device. Make sure the device is powered on and nearby.');
      }
    } catch (e) {
      print('RealBluetoothService: Connection error: $e');
      rethrow;
    }
  }

  /// Internal method to connect to a specific device
  Future<void> _connectToDevice(BluetoothDevice device) async {
    try {
      print('RealBluetoothService: Connecting to ${device.remoteId}...');

      _connectedDevice = device;

      // Listen for connection state changes
      _connectionStateSubscription = device.connectionState.listen((state) {
        print('RealBluetoothService: Connection state changed to $state');
        _isConnected = (state == BluetoothConnectionState.connected);

        if (!_isConnected) {
          print('RealBluetoothService: Device disconnected');
          _cleanup();
        }
      });

      // Connect to device
      await device.connect(timeout: const Duration(seconds: 15));
      print('RealBluetoothService: Connected successfully');

      // Discover services
      print('RealBluetoothService: Discovering services...');
      List<BluetoothService> services = await device.discoverServices();

      // Find our service and characteristic
      for (BluetoothService service in services) {
        if (service.uuid.toString().toLowerCase() == serviceUuid.toLowerCase()) {
          print('RealBluetoothService: Found OxyFeeder service');

          for (BluetoothCharacteristic characteristic in service.characteristics) {
            if (characteristic.uuid.toString().toLowerCase() == characteristicUuid.toLowerCase()) {
              print('RealBluetoothService: Found data characteristic');
              _dataCharacteristic = characteristic;

              // Subscribe to notifications
              await _subscribeToCharacteristic(characteristic);
              break;
            }
          }
          break;
        }
      }

      if (_dataCharacteristic == null) {
        throw Exception('Could not find OxyFeeder service or characteristic');
      }

      _isConnected = true;
      print('RealBluetoothService: Setup complete, receiving data...');
    } catch (e) {
      print('RealBluetoothService: Error connecting to device: $e');
      await disconnect();
      rethrow;
    }
  }

  /// Subscribe to characteristic notifications
  Future<void> _subscribeToCharacteristic(BluetoothCharacteristic characteristic) async {
    try {
      // Enable notifications
      await characteristic.setNotifyValue(true);

      // Listen for data
      _characteristicSubscription = characteristic.lastValueStream.listen((value) {
        if (value.isNotEmpty) {
          try {
            // Convert bytes to string
            String jsonString = utf8.decode(value);
            print('RealBluetoothService: Received data: $jsonString');

            // Parse JSON
            Map<String, dynamic> json = jsonDecode(jsonString);

            // Create OxyFeederStatus object
            OxyFeederStatus status = OxyFeederStatus.fromJson(json);

            // Emit to stream
            _statusStreamController.add(status);
          } catch (e) {
            print('RealBluetoothService: Error parsing data: $e');
          }
        }
      });

      print('RealBluetoothService: Subscribed to notifications');
    } catch (e) {
      print('RealBluetoothService: Error subscribing to characteristic: $e');
      rethrow;
    }
  }

  /// Disconnect from the device
  Future<void> disconnect() async {
    try {
      print('RealBluetoothService: Disconnecting...');
      await _cleanup();
      await _connectedDevice?.disconnect();
      _connectedDevice = null;
      _isConnected = false;
      print('RealBluetoothService: Disconnected');
    } catch (e) {
      print('RealBluetoothService: Error during disconnect: $e');
    }
  }

  /// Clean up subscriptions
  Future<void> _cleanup() async {
    await _scanSubscription?.cancel();
    _scanSubscription = null;

    await _characteristicSubscription?.cancel();
    _characteristicSubscription = null;

    await _connectionStateSubscription?.cancel();
    _connectionStateSubscription = null;

    _dataCharacteristic = null;
  }

  /// Dispose of the service and clean up resources
  @override
  void dispose() {
    print('RealBluetoothService: Disposing...');
    disconnect();
    _statusStreamController.close();
  }
}
