import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/firebase_options.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {

  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text('Registartion Screen ...'),
        backgroundColor: Colors.blueGrey,
      ),

      body: FutureBuilder(

        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),

        builder: (context, asyncSnapshot) {
          switch (asyncSnapshot.connectionState) {
            case ConnectionState.done:
              return Column(
                children: [
                  TextField(
                    controller: _email,

                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,

                    decoration: InputDecoration(hintText: ' Enter your Email'),
                  ),
                  TextField(
                    controller: _password,

                    obscureText: true,
                    autocorrect: false,
                    enableSuggestions: false,

                    decoration: InputDecoration(
                      hintText: ' Enter your Password',
                    ),
                  ),

                  TextButton(
                    onPressed: () async {
                      final email = _email.text;
                      final password = _password.text;


                      try{
                      final userCredential = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                            email: email,
                            password: password,
                          );
                    } 
                    on FirebaseAuthException catch(e){
                      if(e.code == 'weak-password')
                      print('Password too weak, Try a new one. '); 
                      else if(e.code == 'email-already-in-use'){
                        print('This email is already used..'); 
                      }
                      else if(e.code == 'invalid-email')
                      print('The email you entered is not valid'); 
                      else{
                        print(e.code); 
                      }

                    }


                    },
                    child: const Text(
                      'Register',
                      selectionColor: Color.fromARGB(1, 4, 232, 213),
                    ),
                  ),


                  TextButton(onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false); 
                  }, 
                  child: const Text('Login Instead'), )
                ],
              );

            default:
              return const Text('Loading...');
          }
        },
      ),
    );
  }
}