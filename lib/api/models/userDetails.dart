import 'package:meet_your_mates/api/models/providerDetails.dart';

class UserDetails {
  final String providerId;
  final String userName;
  final String photoUrl;
  final String userEmail;
  final List<ProviderDetails> providerData;

  UserDetails(this.providerId, this.userName, this.photoUrl,
      this.userEmail, this.providerData);
}