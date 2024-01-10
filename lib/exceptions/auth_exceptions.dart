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
      case 'wrong-password':
        return const AuthExceptions('he password is invalid for the given email, or the account corresponding to the email does not have a password set.');
      default:
        return const AuthExceptions();
    }
  }
}