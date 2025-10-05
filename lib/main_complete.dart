import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:math';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCfihRhW5pQs438Yzuh1t8g-HzwBW982MY",
      authDomain: "appdata-3966a.firebaseapp.com",
      projectId: "appdata-3966a",
      storageBucket: "appdata-3966a.firebasestorage.app",
      messagingSenderId: "615814131455",
      appId: "1:615814131455:web:2a6b71639fa9f7f283e6ca",
    ),
  );
  runApp(const EmaamulApp());
}

// ================= Constants =================
class AppColors {
  static const Color primary = Color(0xFF002366); // Dark Blue
  static const Color accent = Color(0xFFFF4500); // Orange-Red
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Colors.white;
  static const Color error = Colors.red;
  static const Color success = Colors.green;
}

class SomaliText {
  static const String appName = 'eMaamul';
  static const String login = 'Gal';
  static const String signup = 'Diwaangeli';
  static const String email = 'Iimayl';
  static const String password = 'Sirta';
  static const String admin = 'Maamule';
  static const String agent = 'Wakiil';
  static const String user = 'Isticmaale';
  static const String dashboard = 'Shaashadda Hore';
  static const String income = 'Dakhli';
  static const String expense = 'Kharash';
  static const String products = 'Alaabta';
  static const String reports = 'Warbixinno';
  static const String settings = 'Dejinta';
  static const String chat = 'Sheeko';
  static const String promoCode = 'Koodka Dallacaadda';
  static const String verificationCode = 'Koodka Xaqiijinta';
  static const String verify = 'Xaqiiji';
  static const String create = 'Samee';
  static const String delete = 'Tirtir';
  static const String edit = 'Wax ka beddel';
  static const String save = 'Kaydi';
  static const String cancel = 'Jooji';
  static const String add = 'Ku dar';
  static const String name = 'Magac';
  static const String price = 'Qiime';
  static const String quantity = 'Tiro';
  static const String barcode = 'Koodka Baarkada';
  static const String scan = 'Skan';
  static const String sell = 'Iib';
  static const String commission = 'Ganaax';
  static const String active = 'Firfircoon';
  static const String waiting = 'Sugaya';
  static const String expired = 'Dhacay';
  static const String darkMode = 'Habka Mugdiga';
  static const String language = 'Luqadda';
  static const String currency = 'Lacagta';
  static const String changePassword = 'Sirta Beddel';
  static const String shareApp = 'App-ka Wadaag';
  static const String logout = 'Ka bax';
  static const String total = 'Wadarta';
  static const String today = 'Maanta';
  static const String month = 'Bisha';
  static const String year = 'Sanadka';
  static const String transactions = 'Dhaqdhaqaaqa Lacagta';
  static const String addTransaction = 'Dhaqdhaqaaq Ku dar';
  static const String addProduct = 'Alaab Ku dar';
  static const String scanBarcode = 'Baarkada Skan';
  static const String kobciyeAI = 'KOBCIYE AI';
  static const String sendMessage = 'Fariin Dir';
  static const String typeMessage = 'Fariinta Qor';
}

class EmaamulApp extends StatefulWidget {
  const EmaamulApp({Key? key}) : super(key: key);

  @override
  State<EmaamulApp> createState() => _EmaamulAppState();
}

class _EmaamulAppState extends State<EmaamulApp> {
  bool isDarkMode = false;
  bool isSomali = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('darkMode') ?? false;
      isSomali = prefs.getBool('isSomali') ?? true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: SomaliText.appName,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent,
            foregroundColor: Colors.white,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.accent,
        ),
      ),
      darkTheme: ThemeData(
        primaryColor: AppColors.primary,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent,
            foregroundColor: Colors.white,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.accent,
        ),
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const AuthWrapper(),
    );
  }
}

// ================= Auth Wrapper =================
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        
        if (snapshot.hasData) {
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(snapshot.data!.uid)
                .get(),
            builder: (context, userSnapshot) {
              if (!userSnapshot.hasData) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              
              final userData = userSnapshot.data!.data() as Map<String, dynamic>?;
              if (userData == null) return const LoginScreen();
              
              final role = userData['role'];
              final isActive = userData['active'] ?? false;
              
              switch (role) {
                case 'admin':
                  return AdminScreen();
                case 'agent':
                  return AgentScreen(userId: snapshot.data!.uid);
                case 'user':
                  if (isActive) {
                    return UserDashboard(userId: snapshot.data!.uid);
                  } else {
                    return VerificationScreen(userId: snapshot.data!.uid);
                  }
                default:
                  return const LoginScreen();
              }
            },
          );
        }
        
        return const LoginScreen();
      },
    );
  }
}

// ================= Login Screen =================
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    if (_emailController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fadlan buuxi dhammaan goobaha')),
      );
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      
      // Navigation is handled by AuthWrapper
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Galmada guul darro: ${e.toString()}')),
      );
    }
    
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo and Title
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.business,
                      size: 60,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      SomaliText.appName,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Ganacsiga Yar Maamulka',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Login Form
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Text(
                        SomaliText.login,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: SomaliText.email,
                          prefixIcon: const Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: SomaliText.password,
                          prefixIcon: const Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  SomaliText.login,
                                  style: const TextStyle(fontSize: 18),
                                ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const SignupScreen()),
                          );
                        },
                        child: Text(
                          'Ma lihid akoon? ${SomaliText.signup}',
                          style: TextStyle(color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

// ================= Signup Screen =================
class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _promoController = TextEditingController();
  String _selectedRole = 'user';
  bool _isLoading = false;

  Future<void> _signup() async {
    if (_emailController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fadlan buuxi dhammaan goobaha')),
      );
      return;
    }

    if (_selectedRole == 'user' && _promoController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fadlan gali koodka dallacaadda')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Validate promo code for users
      if (_selectedRole == 'user') {
        final promoQuery = await FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: 'agent')
            .where('promoCode', isEqualTo: _promoController.text.trim())
            .get();
        
        if (promoQuery.docs.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Koodka dallacaadda ma jiro')),
          );
          setState(() => _isLoading = false);
          return;
        }
      }

      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final uid = userCredential.user!.uid;
      String promoCode = '';
      String agentId = '';

      if (_selectedRole == 'agent') {
        promoCode = 'AGENT${DateTime.now().millisecondsSinceEpoch}';
      } else {
        promoCode = _promoController.text.trim();
        // Find agent ID
        final agentQuery = await FirebaseFirestore.instance
            .collection('users')
            .where('promoCode', isEqualTo: promoCode)
            .get();
        if (agentQuery.docs.isNotEmpty) {
          agentId = agentQuery.docs.first.id;
        }
      }

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'email': _emailController.text.trim(),
        'role': _selectedRole,
        'promoCode': promoCode,
        'active': false,
        'agentId': agentId,
        'commission': 0.0,
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Diwaangelinta waa guulaystay!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Diwaangelinta guul darro: ${e.toString()}')),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(SomaliText.signup),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Text(
                          'Akoon Cusub Samee',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Role Selection
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedRole,
                              isExpanded: true,
                              items: [
                                DropdownMenuItem(value: 'user', child: Text(SomaliText.user)),
                                DropdownMenuItem(value: 'agent', child: Text(SomaliText.agent)),
                              ],
                              onChanged: (val) => setState(() => _selectedRole = val!),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: SomaliText.email,
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: SomaliText.password,
                            prefixIcon: const Icon(Icons.lock),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        
                        if (_selectedRole == 'user') ...[
                          const SizedBox(height: 16),
                          TextField(
                            controller: _promoController,
                            decoration: InputDecoration(
                              labelText: SomaliText.promoCode,
                              prefixIcon: const Icon(Icons.card_giftcard),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              helperText: 'Gali koodka wakiilka',
                            ),
                          ),
                        ],
                        
                        const SizedBox(height: 24),
                        
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _signup,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : Text(
                                    SomaliText.signup,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _promoController.dispose();
    super.dispose();
  }
}

// ================= Verification Screen =================
class VerificationScreen extends StatefulWidget {
  final String userId;
  const VerificationScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _codeController = TextEditingController();
  bool _isLoading = false;

  Future<void> _verifyCode() async {
    if (_codeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fadlan gali koodka xaqiijinta')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final doc = await FirebaseFirestore.instance
          .collection('verificationCodes')
          .doc(_codeController.text.trim())
          .get();

      if (!doc.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Koodka ma jiro')),
        );
        setState(() => _isLoading = false);
        return;
      }

      final data = doc.data()!;
      final expireDate = (data['expireDate'] as Timestamp).toDate();
      final assignedUser = data['userId'];

      if (assignedUser != widget.userId) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Koodkan ma aha kuwaaga')),
        );
      } else if (DateTime.now().isAfter(expireDate)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Koodka wuu dhacay')),
        );
      } else {
        // Activate user
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId)
            .update({'active': true});

        // Update agent commission if any
        final agentId = data['agentId'];
        if (agentId != null && agentId.isNotEmpty) {
          final agentDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(agentId)
              .get();
          
          if (agentDoc.exists) {
            double currentCommission = (agentDoc.data()!['commission'] ?? 0.0).toDouble();
            currentCommission += 7 * 0.35; // 35% of $7
            
            await FirebaseFirestore.instance
                .collection('users')
                .doc(agentId)
                .update({'commission': currentCommission});
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Xaqiijinta waa guulaystay!')),
        );
        
        // Navigation handled by AuthWrapper
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Khalad: ${e.toString()}')),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(SomaliText.verificationCode),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.verified_user,
                        size: 80,
                        color: AppColors.primary,
                      ),
                      
                      const SizedBox(height: 20),
                      
                      Text(
                        'Akoonka Xaqiiji',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      
                      const SizedBox(height: 10),
                      
                      Text(
                        'Gali koodka xaqiijinta ee maamulaha kuu siiyay',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      TextField(
                        controller: _codeController,
                        decoration: InputDecoration(
                          labelText: SomaliText.verificationCode,
                          prefixIcon: const Icon(Icons.vpn_key),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          hintText: 'EM...',
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _verifyCode,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  SomaliText.verify,
                                  style: const TextStyle(fontSize: 18),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }
}
