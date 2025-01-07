class InfoEntity {
  final AboutEntity about;
  final DeliveryInfoEntity deliveryInfo;
  final ContactEntity contact;
  final String openingTimes;

  const InfoEntity({
    required this.about,
    required this.deliveryInfo,
    required this.contact,
    required this.openingTimes,
  });
}

class AboutEntity {
  final String informationId;
  final String bottom;
  final String sortOrder;
  final String status;
  final String languageId;
  final String title;
  final String description;
  final String metaTitle;
  final String metaDescription;
  final String metaKeyword;
  final String storeId;

  const AboutEntity({
    required this.informationId,
    required this.bottom,
    required this.sortOrder,
    required this.status,
    required this.languageId,
    required this.title,
    required this.description,
    required this.metaTitle,
    required this.metaDescription,
    required this.metaKeyword,
    required this.storeId,
  });
}

class DeliveryInfoEntity {
  final String informationId;
  final String bottom;
  final String sortOrder;
  final String status;
  final String languageId;
  final String title;
  final String description;
  final String metaTitle;
  final String metaDescription;
  final String metaKeyword;
  final String storeId;

  const DeliveryInfoEntity({
    required this.informationId,
    required this.bottom,
    required this.sortOrder,
    required this.status,
    required this.languageId,
    required this.title,
    required this.description,
    required this.metaTitle,
    required this.metaDescription,
    required this.metaKeyword,
    required this.storeId,
  });
}

class ContactEntity {
  final String store;
  final String address;
  final String telephone;
  final String email;

  const ContactEntity({
    required this.store,
    required this.address,
    required this.telephone,
    required this.email,
  });
}
