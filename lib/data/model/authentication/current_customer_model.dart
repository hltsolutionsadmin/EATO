class CurrentCustomerModel {
    CurrentCustomerModel({
        required this.id,
        required this.fullName,
        required this.roles,
        required this.primaryContact,
        required this.creationTime,
        required this.version,
        required this.skillrat,
        required this.yardly,
        required this.eato,
        required this.sancharalakshmi,
        required this.registered,
    });

    final int? id;
    final String? fullName;
    final List<Role> roles;
    final String? primaryContact;
    final DateTime? creationTime;
    final int? version;
    final bool? skillrat;
    final bool? yardly;
    final bool? eato;
    final bool? sancharalakshmi;
    final bool? registered;

    factory CurrentCustomerModel.fromJson(Map<String, dynamic> json){ 
        return CurrentCustomerModel(
            id: json["id"],
            fullName: json["fullName"],
            roles: json["roles"] == null ? [] : List<Role>.from(json["roles"]!.map((x) => Role.fromJson(x))),
            primaryContact: json["primaryContact"],
            creationTime: DateTime.tryParse(json["creationTime"] ?? ""),
            version: json["version"],
            skillrat: json["skillrat"],
            yardly: json["yardly"],
            eato: json["eato"],
            sancharalakshmi: json["sancharalakshmi"],
            registered: json["registered"],
        );
    }

}

class Role {
    Role({
        required this.name,
        required this.id,
    });

    final String? name;
    final int? id;

    factory Role.fromJson(Map<String, dynamic> json){ 
        return Role(
            name: json["name"],
            id: json["id"],
        );
    }

}
