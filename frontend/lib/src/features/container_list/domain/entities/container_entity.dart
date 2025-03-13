class ContainerEntity {
  final String id;
  final String ip;
  final int pingTime;
  final DateTime lastSuccessfulPing;

  ContainerEntity({
    required this.id,
    required this.ip,
    required this.pingTime,
    required this.lastSuccessfulPing,
  });
}
