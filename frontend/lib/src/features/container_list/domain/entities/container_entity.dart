class ContainerEntity {
  final int? id;
  final String containerName;
  final String ipAddress;
  final double pingTime;
  final DateTime lastSuccess;

  ContainerEntity({
    required this.id,
    required this.containerName,
    required this.ipAddress,
    required this.pingTime,
    required this.lastSuccess,
  });

  ContainerEntity copyWith({
    int? id,
    String? containerName,
    String? ipAddress,
    double? pingTime,
    DateTime? lastSuccess,
  }) {
    return ContainerEntity(
      id: id ?? this.id,
      containerName: containerName ?? this.containerName,
      ipAddress: ipAddress ?? this.ipAddress,
      pingTime: pingTime ?? this.pingTime,
      lastSuccess: lastSuccess ?? this.lastSuccess,
    );
  }
}
