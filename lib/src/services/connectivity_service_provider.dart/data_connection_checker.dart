import 'dart:io';
import 'dart:async';

enum DataConnectionStatus {
  disconnected,
  connected,
}

class DataConnectionChecker {
  static const int defaultPort = 53;
  static const Duration defaultTimeout = Duration(seconds: 10);

  static const Duration defaultInterval = Duration(seconds: 10);

  static final List<AddressCheckOptions> defaultAddresses =
  List<AddressCheckOptions>.unmodifiable(
    <AddressCheckOptions>[
      AddressCheckOptions(
        InternetAddress(
          '1.1.1.1', // CloudFlare
          type: InternetAddressType.IPv4,
        ),
      ),
      AddressCheckOptions(
        InternetAddress(
          '2606:4700:4700::1111', // CloudFlare
          type: InternetAddressType.IPv6,
        ),
      ),
      AddressCheckOptions(
        InternetAddress(
          '8.8.4.4', // Google
          type: InternetAddressType.IPv4,
        ),
      ),
      AddressCheckOptions(
        InternetAddress(
          '2001:4860:4860::8888', // Google
          type: InternetAddressType.IPv6,
        ),
      ),
      AddressCheckOptions(
        InternetAddress(
          '208.67.222.222', // OpenDNS
          type: InternetAddressType.IPv4,
        ), // OpenDNS
      ),
      AddressCheckOptions(
        InternetAddress(
          '2620:0:ccc::2', // OpenDNS
          type: InternetAddressType.IPv6,
        ), // OpenDNS
      ),
    ],
  );

  List<AddressCheckOptions> addresses = defaultAddresses;

  factory DataConnectionChecker() => _instance;

  DataConnectionChecker._() {
    _statusController.onListen = () {
      _maybeEmitStatusUpdate();
    };
    _statusController.onCancel = () {
      _timerHandle?.cancel();
      _lastStatus = null; // reset last status
    };
  }

  static final DataConnectionChecker _instance = DataConnectionChecker._();

  Future<AddressCheckResult> isHostReachable(
      AddressCheckOptions options,
      ) async {
    Socket? sock;
    try {
      sock = await Socket.connect(
        options.address,
        options.port,
        timeout: options.timeout,
      );
      sock.destroy();
      return AddressCheckResult(options, true);
    } catch (e) {
      sock?.destroy();
      return AddressCheckResult(options, false);
    }
  }

  Future<bool> get hasConnection async {
    final Completer<bool> result = Completer<bool>();
    int length = addresses.length;

    for (final AddressCheckOptions addressOptions in addresses) {
      isHostReachable(addressOptions).then(
            (AddressCheckResult request) {
          length -= 1;
          if (!result.isCompleted) {
            if (request.isSuccess) {
              result.complete(true);
            } else if (length == 0) {
              result.complete(false);
            }
          }
        },
      );
    }

    return result.future;
  }

  Future<DataConnectionStatus> get connectionStatus async {
    return await hasConnection
        ? DataConnectionStatus.connected
        : DataConnectionStatus.disconnected;
  }

  Duration checkInterval = defaultInterval;

  Future<void> _maybeEmitStatusUpdate([Timer? timer]) async {
    _timerHandle?.cancel();
    timer?.cancel();

    final DataConnectionStatus currentStatus = await connectionStatus;

    if (_lastStatus != currentStatus && _statusController.hasListener) {
      _statusController.add(currentStatus);
    }

    if (!_statusController.hasListener) return;
    _timerHandle = Timer(checkInterval, _maybeEmitStatusUpdate);

    _lastStatus = currentStatus;
  }

  DataConnectionStatus? _lastStatus;
  Timer? _timerHandle;

  final StreamController<DataConnectionStatus> _statusController =
  StreamController.broadcast();

  Stream<DataConnectionStatus> get onStatusChange => _statusController.stream;

  bool get hasListeners => _statusController.hasListener;

  bool get isActivelyChecking => _statusController.hasListener;
}

class AddressCheckOptions {
  final InternetAddress address;
  final int port;
  final Duration timeout;

  AddressCheckOptions(
      this.address, {
        this.port = DataConnectionChecker.defaultPort,
        this.timeout = DataConnectionChecker.defaultTimeout,
      });

  @override
  String toString() => "AddressCheckOptions($address, $port, $timeout)";
}
class AddressCheckResult {
  final AddressCheckOptions options;
  final bool isSuccess;

  AddressCheckResult(
      this.options,
      this.isSuccess,
      );

  @override
  String toString() => "AddressCheckResult($options, $isSuccess)";
}
