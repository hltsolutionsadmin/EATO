class CurrentCustomerModel {
  int? id;
  List<Roles>? roles;
  String? primaryContact;
  String? creationTime;
  int? version;
  bool? registered;

  CurrentCustomerModel(
      {this.id,
      this.roles,
      this.primaryContact,
      this.creationTime,
      this.version,
      this.registered});

  CurrentCustomerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['roles'] != null) {
      roles = <Roles>[];
      json['roles'].forEach((v) {
        roles!.add(Roles.fromJson(v));
      });
    }
    primaryContact = json['primaryContact'];
    creationTime = json['creationTime'];
    version = json['version'];
    registered = json['registered'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (roles != null) {
      data['roles'] = roles!.map((v) => v.toJson()).toList();
    }
    data['primaryContact'] = primaryContact;
    data['creationTime'] = creationTime;
    data['version'] = version;
    data['registered'] = registered;
    return data;
  }
}

class Roles {
  String? name;
  int? id;

  Roles({this.name, this.id});

  Roles.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    return data;
  }
}
