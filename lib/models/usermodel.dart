class UserModel {
  String fullName;
  String email;
  String emergencyContact;
  String currentDestination;
  String touristId;
  String nationality;
  String age;
  String gender;
  String mobileNumber;
  String hotelAddress;
  String localGuideContact;
  String emergencyContactName;
  String emergencyContactPhone;
  String emergencyContactRelation;
  String insuranceCompany;
  String insurancePolicyNumber;

  // Additional fields for backend integration
  String? id;
  String? profilePhoto;
  String? bloodGroup;
  List<String> allergies;
  List<String> medications;
  bool isActive;
  bool isVerified;
  String blockchainStatus;
  DateTime? createdAt;
  DateTime? updatedAt;

  UserModel({
    this.fullName = '',
    this.email = '',
    this.emergencyContact = '',
    this.currentDestination = '',
    this.touristId = '',
    this.nationality = '',
    this.age = '',
    this.gender = '',
    this.mobileNumber = '',
    this.hotelAddress = '',
    this.localGuideContact = '',
    this.emergencyContactName = '',
    this.emergencyContactPhone = '',
    this.emergencyContactRelation = '',
    this.insuranceCompany = '',
    this.insurancePolicyNumber = '',
    // New fields
    this.id,
    this.profilePhoto,
    this.bloodGroup = '',
    this.allergies = const [],
    this.medications = const [],
    this.isActive = true,
    this.isVerified = false,
    this.blockchainStatus = 'PENDING',
    this.createdAt,
    this.updatedAt,
  });

  // Convert from JSON (from backend API response)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? json['id'],
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      emergencyContact: json['emergencyContact'] ?? '',
      currentDestination: json['currentDestination'] ?? '',
      touristId: json['touristId'] ?? '',
      nationality: json['nationality'] ?? '',
      age: json['age']?.toString() ?? '',
      gender: json['gender'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      hotelAddress: json['hotelAddress'] ?? '',
      localGuideContact: json['localGuideContact'] ?? '',
      emergencyContactName: json['emergencyContactName'] ?? '',
      emergencyContactPhone: json['emergencyContactPhone'] ?? '',
      emergencyContactRelation: json['emergencyContactRelation'] ?? '',
      insuranceCompany: json['insuranceCompany'] ?? '',
      insurancePolicyNumber: json['insurancePolicyNumber'] ?? '',
      profilePhoto: json['profilePhoto'],
      bloodGroup: json['bloodGroup'] ?? '',
      allergies: List<String>.from(json['allergies'] ?? []),
      medications: List<String>.from(json['medications'] ?? []),
      isActive: json['isActive'] ?? true,
      isVerified: json['isVerified'] ?? false,
      blockchainStatus: json['blockchainStatus'] ?? 'PENDING',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  // Convert to JSON (for backend API requests)
  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'fullName': fullName,
      'email': email,
      'emergencyContact': emergencyContact,
      'currentDestination': currentDestination,
      'touristId': touristId,
      'nationality': nationality,
      'age': age,
      'gender': gender,
      'mobileNumber': mobileNumber,
      'hotelAddress': hotelAddress,
      'localGuideContact': localGuideContact,
      'emergencyContactName': emergencyContactName,
      'emergencyContactPhone': emergencyContactPhone,
      'emergencyContactRelation': emergencyContactRelation,
      'insuranceCompany': insuranceCompany,
      'insurancePolicyNumber': insurancePolicyNumber,
      if (profilePhoto != null) 'profilePhoto': profilePhoto,
      'bloodGroup': bloodGroup,
      'allergies': allergies,
      'medications': medications,
      'isActive': isActive,
      'isVerified': isVerified,
      'blockchainStatus': blockchainStatus,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }

  // Copy with method for updating specific fields
  UserModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? emergencyContact,
    String? currentDestination,
    String? touristId,
    String? nationality,
    String? age,
    String? gender,
    String? mobileNumber,
    String? hotelAddress,
    String? localGuideContact,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? emergencyContactRelation,
    String? insuranceCompany,
    String? insurancePolicyNumber,
    String? profilePhoto,
    String? bloodGroup,
    List<String>? allergies,
    List<String>? medications,
    bool? isActive,
    bool? isVerified,
    String? blockchainStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      currentDestination: currentDestination ?? this.currentDestination,
      touristId: touristId ?? this.touristId,
      nationality: nationality ?? this.nationality,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      hotelAddress: hotelAddress ?? this.hotelAddress,
      localGuideContact: localGuideContact ?? this.localGuideContact,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactPhone:
          emergencyContactPhone ?? this.emergencyContactPhone,
      emergencyContactRelation:
          emergencyContactRelation ?? this.emergencyContactRelation,
      insuranceCompany: insuranceCompany ?? this.insuranceCompany,
      insurancePolicyNumber:
          insurancePolicyNumber ?? this.insurancePolicyNumber,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      allergies: allergies ?? this.allergies,
      medications: medications ?? this.medications,
      isActive: isActive ?? this.isActive,
      isVerified: isVerified ?? this.isVerified,
      blockchainStatus: blockchainStatus ?? this.blockchainStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Validation methods
  bool get isValidProfile {
    return fullName.isNotEmpty &&
        email.isNotEmpty &&
        touristId.isNotEmpty &&
        mobileNumber.isNotEmpty &&
        emergencyContactName.isNotEmpty &&
        emergencyContactPhone.isNotEmpty;
  }

  bool get hasEmergencyInfo {
    return emergencyContactName.isNotEmpty && emergencyContactPhone.isNotEmpty;
  }

  bool get isBlockchainVerified {
    return blockchainStatus == 'VALID' || blockchainStatus == 'VERIFIED';
  }

  // Get display name
  String get displayName {
    return fullName.isNotEmpty ? fullName : 'Tourist ${touristId}';
  }

  // Get emergency contact summary
  String get emergencyContactSummary {
    if (emergencyContactName.isEmpty) return 'Not provided';
    return '$emergencyContactName (${emergencyContactRelation}) - $emergencyContactPhone';
  }

  @override
  String toString() {
    return 'UserModel(id: $id, touristId: $touristId, fullName: $fullName, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.touristId == touristId;
  }

  @override
  int get hashCode => touristId.hashCode;
}
