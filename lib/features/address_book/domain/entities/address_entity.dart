class AddressEntity {
  final int addressId;
  final String firstName;
  final String lastName;
  final String? company;
  final String address1;
  final String? address2;
  final String city;
  final String postcode;
  final String zone;
  final String zoneCode;
  final String country;

  const AddressEntity({
    required this.addressId,
    required this.firstName,
    required this.lastName,
    required this.company,
    required this.address1,
    required this.address2,
    required this.city,
    required this.postcode,
    required this.zone,
    required this.zoneCode,
    required this.country,
  });

}
