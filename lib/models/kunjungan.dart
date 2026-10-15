class Kunjungan {
  final int? id;
  final String namaPelanggan;
  final String alamat;
  final String noHp;
  final String catatan;
  final double? latitude;
  final double? longitude;
  final DateTime tanggal;

  const Kunjungan({
    this.id,
    required this.namaPelanggan,
    required this.alamat,
    required this.noHp,
    this.catatan = '',
    this.latitude,
    this.longitude,
    required this.tanggal,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'nama_pelanggan': namaPelanggan,
    'alamat': alamat,
    'no_hp': noHp,
    'catatan': catatan,
    'latitude': latitude,
    'longitude': longitude,
    'tanggal': tanggal.toIso8601String(),
  };

  factory Kunjungan.fromMap(Map<String, dynamic> map) => Kunjungan(
    id: map['id'] as int?,
    namaPelanggan: map['nama_pelanggan'] as String,
    alamat: map['alamat'] as String,
    noHp: map['no_hp'] as String,
    catatan: map['catatan'] as String? ?? '',
    latitude: map['latitude'] as double?,
    longitude: map['longitude'] as double?,
    tanggal: DateTime.parse(map['tanggal'] as String),
  );
}
