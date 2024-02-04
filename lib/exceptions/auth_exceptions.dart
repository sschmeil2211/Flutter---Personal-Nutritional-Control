class AuthExceptions{
  final String message;

  const AuthExceptions([this.message = "An unknown error occurred."]);

  factory AuthExceptions.code(String code){
    switch(code){
      case 'weak-password':
        return const AuthExceptions('Please enter a stronger password.');
      case 'invalid-email':
        return const AuthExceptions('Email is not valid or badly formatted');
      case 'email-already-in-use':
        return const AuthExceptions('An account already exists for that email.');
      case 'operation-not-allowed':
        return const AuthExceptions('Operation is not allowed. Please contact support.');
      case 'user-disabled':
        return const AuthExceptions('This user has been disabled. Please contact support for help.');
      case 'user-not-found':
        return const AuthExceptions('There is no user corresponding to the email provided.');
      case 'missing-android-pkg-name':
        return const AuthExceptions('An Android package name must be provided if the Android app is required to be installed.');
      case 'wrong-password':
        return const AuthExceptions('He password is invalid for the given email, or the account corresponding to the email does not have a password set.');
      case 'missing-continue-uri':
        return const AuthExceptions('A continue URL must be provided in the request.');
      case 'missing-ios-bundle-id':
        return const AuthExceptions('An iOS Bundle ID must be provided if an App Store ID is provided.');
      case 'invalid-continue-uri':
        return const AuthExceptions('The continue URL provided in the request is invalid.');
      case 'unauthorized-continue-uri':
        return const AuthExceptions('The domain of the continue URL is not whitelisted. Whitelist the domain in the Firebase console.');
      case 'account-exists-with-different-credential':
        return const AuthExceptions('There already exists an account with the email address asserted by the credential. Resolve this by calling fetchSignInMethodsForEmail and then asking the user to sign in using one of the returned providers. Once the user is signed in, the original credential can be linked to the user with linkWithCredential.');
      case 'invalid-credential':
        return const AuthExceptions('The credential is malformed or has expired');
      case 'invalid-verification-code':
        return const AuthExceptions('The credential is a PhoneAuthProvider.credential and the verification code of the credential is not valid.');
      case 'invalid-verification-id':
        return const AuthExceptions('The credential is a PhoneAuthProvider.credential and the verification ID of the credential is not valid.id.');
      default:
        return const AuthExceptions();
    }
  }
}