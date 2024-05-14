import 'dart:math';

class Password {
  String password ;
  int length; 
  Password({
    this.password = '',
    required this.length
  });
  
  String generatePassword() { 
    final random = Random(); 
    // const characters ='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()_+';
    const characters ='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789*'; 
    String password = ''; 
    for (int i = 0; i < length; i++) { 
      password += characters[random.nextInt(characters.length)];  
    } 
  return password;
  } 
}