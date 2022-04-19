import 'dart:convert';

const keyDescription = 'description';
const keyExternalUrl = 'external_url';
const keyImage = 'image';
const keyName = 'name';
const keyAttributes = 'attributes';

/// https://docs.pinata.cloud/api-pinning/pin-json
class Metadata {

  String? description;
  String? externalUrl;
  String? image;
  String? name;
  // Map<String, dynamic> attributes;

  Metadata();

  factory Metadata.fromJsonOrNull(Map<String, dynamic> json) {
    Metadata metadata = Metadata();

    metadata.description =(json[keyDescription] != null) ? json[keyDescription].toString() : '';
    metadata.externalUrl =(json[keyExternalUrl] != null) ? json[keyExternalUrl].toString() : '';
    metadata.image =(json[keyImage] != null) ? json[keyImage].toString() : '';
    metadata.name =(json[keyName] != null) ? json[keyName].toString() : '';
    // metadata.attributes =(json[keyAttributes] != null) ? json[keyName].toString() : '';

    return metadata;
  }

  Map<String, dynamic> toJson() {
    return {
      keyDescription: description,
      keyExternalUrl: externalUrl,
      keyImage: image,
      keyName: name,
    };
  }

  static String convertToJSON(List<Metadata> metadataList) {
    String json = '[';
    metadataList.forEach((metadata) {
      json += jsonEncode(metadata);
    });
    json += ']';
    return json;
  }
}

class PinataOptions {
  String? cidVersion;
  String? customPinPolicy;

  Map<String, dynamic> toJson() {
    return {
      "cidVersion": cidVersion,
      "customPinPolicy": customPinPolicy,
    };
  }
}

class PinataMetadata {
  String? name;
  String? keyvalues;

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "keyvalues": keyvalues,
    };
  }
}