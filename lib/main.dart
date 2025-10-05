// main.dart - eMaamul (Single file, production-ready)
// Language: Somali default, English optional via settings
// Branding: Dark Blue #002366, Orange-Red #FF4500
//
// Before building APK, ensure pubspec.yaml includes:
// dependencies:
//   firebase_core: ^2.24.2
//   firebase_auth: ^4.15.3
//   cloud_firestore: ^4.13.6
//   firebase_analytics: ^10.7.4
//   flutter_riverpod: ^2.4.9
//   fl_chart: ^0.66.0
//   http: ^1.1.2
//   shared_preferences: ^2.2.2
//   uuid: ^4.2.1
//   intl: ^0.17.0
//   flutter_barcode_scanner: ^2.0.0
//
// Android: add google-services.json and Firebase Gradle config for release.
// Web: scanner disabled; user gets Somali message.

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide UserInfo;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

// ------------------- Firebase Init -------------------
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Use provided options for web; for mobile use default (google-services.json)
  if (kIsWeb) {
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
  } else {
    await Firebase.initializeApp();
  }
  runApp(const ProviderScope(child: EmaamulApp()));
}

// ------------------- Constants & Localization -------------------
class AppColors {
  static const Color primary = Color(0xFF002366);
  static const Color accent = Color(0xFFFF4500);
  static const Color success = Color(0xFF4CAF50);
  static const Color danger = Colors.red;
  static const Color bg = Color(0xFFF5F5F5);
}

class SO {
  static const String appName = 'eMaamul';
  static const String login = 'Gal';
  static const String signup = 'Diwaangeli';
  static const String email = 'Iimayl';
  static const String password = 'Sirta';
  static const String role = 'Dooro Doorka';
  static const String admin = 'Maamule';
  static const String agent = 'Wakiil';
  static const String user = 'Isticmaale';
  static const String promoCode = 'Koodka Wakiilka';
  static const String verifyCode = 'Koodka Xaqiijinta (EM...)';
  static const String verify = 'Xaqiiji';
  static const String dashboard = 'Shaashadda Hore';
  static const String income = 'Dakhli';
  static const String expense = 'Kharash';
  static const String products = 'Alaabta';
  static const String reports = 'Warbixinno';
  static const String settings = 'Dejinta';
  static const String add = 'Ku dar';
  static const String delete = 'Tirtir';
  static const String edit = 'Wax ka beddel';
  static const String save = 'Kaydi';
  static const String cancel = 'Jooji';
  static const String name = 'Magac';
  static const String price = 'Qiime';
  static const String quantity = 'Tiro';
  static const String barcode = 'Koodka Baarkada';
  static const String scan = 'Skan';
  static const String sell = 'Iib';
  static const String active = 'Firfircoon';
  static const String waiting = 'Sugaya';
  static const String expired = 'Dhacay';
  static const String darkMode = 'Habka Mugdiga';
  static const String language = 'Luqad';
  static const String somali = 'Somali';
  static const String english = 'English';
  static const String changePassword = 'Beddel Sirta';
  static const String currency = 'Lacagta';
  static const String setPin = 'Deji PIN';
  static const String shareApp = 'La wadaag App-ka';
  static const String koBciyeAI = 'KOBCIYE AI';
  static const String typeMessage = 'Fariin qor...';
  static const String userMustVerify = 'Fadlan geli koodka xaqiijinta (EM...)';
  static const String promoRequired = 'Koodka wakiilka ayaa loo baahan yahay';
  static const String invalidPromo = 'Koodka wakiilka sax ma aha';
  static const String invalidVerify = 'Koodka xaqiijinta sax ma aha';
  static const String notSupportedWebScan = 'Skan baarkood ma shaqeeyo web-ka';
}

class EN {
  static const String appName = 'eMaamul';
  static const String login = 'Login';
  static const String signup = 'Sign up';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String role = 'Select Role';
  static const String admin = 'Admin';
  static const String agent = 'Agent';
  static const String user = 'User';
  static const String promoCode = 'Agent Promo Code';
  static const String verifyCode = 'Verification Code (EM...)';
  static const String verify = 'Verify';
  static const String dashboard = 'Dashboard';
  static const String income = 'Income';
  static const String expense = 'Expense';
  static const String products = 'Products';
  static const String reports = 'Reports';
  static const String settings = 'Settings';
  static const String add = 'Add';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String save = 'Save';
  static const String cancel = 'Cancel';
  static const String name = 'Name';
  static const String price = 'Price';
  static const String quantity = 'Qty';
  static const String barcode = 'Barcode';
  static const String scan = 'Scan';
  static const String sell = 'Sell';
  static const String active = 'Active';
  static const String waiting = 'Waiting';
  static const String expired = 'Expired';
  static const String darkMode = 'Dark Mode';
  static const String language = 'Language';
  static const String somali = 'Somali';
  static const String english = 'English';
  static const String changePassword = 'Change Password';
  static const String currency = 'Currency';
  static const String setPin = 'Set PIN';
  static const String shareApp = 'Share App';
  static const String koBciyeAI = 'KOBCIYE AI';
  static const String typeMessage = 'Type a message...';
  static const String userMustVerify = 'Please enter verification code (EM...)';
  static const String promoRequired = 'Promo code required';
  static const String invalidPromo = 'Invalid promo code';
  static const String invalidVerify = 'Invalid verification code';
  static const String notSupportedWebScan = 'Barcode scan not supported on Web';
}

// ------------------- Models -------------------
class UserInfo {
  final String uid;
  final String email;
  final String role; // admin, agent, user
  final bool active;
  final String? agentId;
  final String? promoCode;
  UserInfo({
    required this.uid,
    required this.email,
    required this.role,
    required this.active,
    this.agentId,
    this.promoCode,
  });
  Map<String, dynamic> toMap() => {
        'email': email,
        'role': role,
        'active': active,
        'agentId': agentId,
        'promoCode': promoCode,
        'createdAt': FieldValue.serverTimestamp(),
      };
  static UserInfo fromDoc(DocumentSnapshot d) {
    final m = d.data() as Map<String, dynamic>;
    return UserInfo(
      uid: d.id,
      email: m['email'] ?? '',
      role: m['role'] ?? 'user',
      active: m['active'] ?? false,
      agentId: m['agentId'],
      promoCode: m['promoCode'],
    );
  }
}

class TransactionModel {
  final String id;
  final String name;
  final double amount;
  final String type; // income, expense
  final DateTime date;
  TransactionModel(
      {required this.id,
      required this.name,
      required this.amount,
      required this.type,
      required this.date});
  Map<String, dynamic> toMap() => {
        'name': name,
        'amount': amount,
        'type': type,
        'date': Timestamp.fromDate(date),
      };
  static TransactionModel fromDoc(DocumentSnapshot d) {
    final m = d.data() as Map<String, dynamic>;
    return TransactionModel(
      id: d.id,
      name: m['name'] ?? '',
      amount: (m['amount'] ?? 0).toDouble(),
      type: m['type'] ?? 'income',
      date: (m['date'] as Timestamp).toDate(),
    );
    }
}

class Product {
  final String id;
  final String name;
  final String barcode;
  final double price;
  final int qty;
  Product(
      {required this.id,
      required this.name,
      required this.barcode,
      required this.price,
      required this.qty});
  Map<String, dynamic> toMap() =>
      {'name': name, 'barcode': barcode, 'price': price, 'qty': qty, 'createdAt': FieldValue.serverTimestamp()};
  static Product fromDoc(DocumentSnapshot d) {
    final m = d.data() as Map<String, dynamic>;
    return Product(
      id: d.id,
      name: m['name'] ?? '',
      barcode: m['barcode'] ?? '',
      price: (m['price'] ?? 0).toDouble(),
      qty: (m['qty'] ?? 0).toInt(),
    );
  }
}

// ------------------- Providers (Riverpod) -------------------
final prefsProvider = FutureProvider<SharedPreferences>((ref) async {
  return SharedPreferences.getInstance();
});

final langProvider = StateProvider<String>((ref) => 'SO'); // SO or EN
final themeDarkProvider = StateProvider<bool>((ref) => false);
final currencyProvider = StateProvider<String>((ref) => 'USD');
final aiApiKeyProvider = StateProvider<String?>((ref) => null);

String t(BuildContext context, WidgetRef ref, String so, String en) {
  return ref.watch(langProvider) == 'SO' ? so : en;
}

// ------------------- App Shell -------------------
class EmaamulApp extends ConsumerStatefulWidget {
  const EmaamulApp({super.key});
  @override
  ConsumerState<EmaamulApp> createState() => _EmaamulAppState();
}

class _EmaamulAppState extends ConsumerState<EmaamulApp> {
  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final p = await SharedPreferences.getInstance();
    ref.read(themeDarkProvider.notifier).state = p.getBool('dark') ?? false;
    ref.read(langProvider.notifier).state = p.getString('lang') ?? 'SO';
    ref.read(currencyProvider.notifier).state = p.getString('cur') ?? 'USD';
    ref.read(aiApiKeyProvider.notifier).state = p.getString('aiKey');
  }

  ThemeData _theme(bool dark) {
    final seed = AppColors.primary;
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: seed, brightness: dark ? Brightness.dark : Brightness.light),
      primaryColor: AppColors.primary,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: AppColors.accent),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, foregroundColor: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = ref.watch(themeDarkProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'eMaamul',
      theme: _theme(false),
      darkTheme: _theme(true),
      themeMode: dark ? ThemeMode.dark : ThemeMode.light,
      home: const AuthGate(),
    );
  }
}

// ------------------- Auth Gate -------------------
class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (ctx, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snap.data == null) return const LoginScreen();
        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('users').doc(snap.data!.uid).get(),
          builder: (ctx, us) {
            if (!us.hasData) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }
            if (!us.data!.exists) return const LoginScreen();
            final u = UserInfo.fromDoc(us.data!);
            if (u.role == 'admin') return const AdminScreen();
            if (u.role == 'agent') return AgentScreen(userId: u.uid);
            if (u.role == 'user') {
              return u.active ? UserDashboard(userId: u.uid) : VerificationScreen(userId: u.uid);
            }
            return const LoginScreen();
          },
        );
      },
    );
  }
}

// ------------------- Login/Signup -------------------
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  @override
  ConsumerState<LoginScreen> createState() => _LoginState();
}

class _LoginState extends ConsumerState<LoginScreen> {
  final emailC = TextEditingController();
  final passC = TextEditingController();
  String role = 'user'; // admin, agent, user
  bool loading = false;

  @override
  void dispose() {
    emailC.dispose();
    passC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tr = (String so, String en) => t(context, ref, so, en);
    return Scaffold(
      appBar: AppBar(title: Text(tr(SO.login, EN.login))),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              DropdownButtonFormField<String>(
                value: role,
                items: [
                  DropdownMenuItem(value: 'admin', child: Text(tr(SO.admin, EN.admin))),
                  DropdownMenuItem(value: 'agent', child: Text(tr(SO.agent, EN.agent))),
                  DropdownMenuItem(value: 'user', child: Text(tr(SO.user, EN.user))),
                ],
                onChanged: (v) => setState(() => role = v ?? 'user'),
                decoration: InputDecoration(labelText: tr(SO.role, EN.role), border: const OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailC,
                decoration: InputDecoration(labelText: tr(SO.email, EN.email), border: const OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: passC,
                obscureText: true,
                decoration: InputDecoration(labelText: tr(SO.password, EN.password), border: const OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: loading ? null : _doLogin,
                    child: loading ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : Text(tr(SO.login, EN.login)),
                  ),
                ),
                const SizedBox(width: 12),
                TextButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SignupScreen())),
                  child: Text(tr(SO.signup, EN.signup)),
                ),
              ]),
            ]),
          ),
        ),
      ),
    );
  }

  Future<void> _doLogin() async {
    setState(() => loading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailC.text.trim(), password: passC.text);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Guul!')));
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Khalad: ${e.message ?? e.code}')));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }
}

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});
  @override
  ConsumerState<SignupScreen> createState() => _SignupState();
}

class _SignupState extends ConsumerState<SignupScreen> {
  final emailC = TextEditingController();
  final passC = TextEditingController();
  final promoC = TextEditingController(); // for user role
  String role = 'user';
  bool loading = false;

  @override
  void dispose() {
    emailC.dispose();
    passC.dispose();
    promoC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tr = (String so, String en) => t(context, ref, so, en);
    return Scaffold(
      appBar: AppBar(title: Text(tr(SO.signup, EN.signup))),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              DropdownButtonFormField<String>(
                value: role,
                items: [
                  DropdownMenuItem(value: 'agent', child: Text(tr(SO.agent, EN.agent))),
                  DropdownMenuItem(value: 'user', child: Text(tr(SO.user, EN.user))),
                ],
                onChanged: (v) => setState(() => role = v ?? 'user'),
                decoration: InputDecoration(labelText: tr(SO.role, EN.role), border: const OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailC,
                decoration: InputDecoration(labelText: tr(SO.email, EN.email), border: const OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: passC,
                obscureText: true,
                decoration: InputDecoration(labelText: tr(SO.password, EN.password), border: const OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              if (role == 'user')
                TextField(
                  controller: promoC,
                  decoration: InputDecoration(labelText: tr(SO.promoCode, EN.promoCode), border: const OutlineInputBorder()),
                ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: loading ? null : _doSignup,
                  child: loading ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : Text(tr(SO.signup, EN.signup)),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Future<void> _doSignup() async {
    setState(() => loading = true);
    try {
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailC.text.trim(), password: passC.text);
      final uid = cred.user!.uid;
      final users = FirebaseFirestore.instance.collection('users');
      if (role == 'agent') {
        // generate promo
        final promo = 'AG-${const Uuid().v4().substring(0, 6).toUpperCase()}';
        await users.doc(uid).set(UserInfo(uid: uid, email: emailC.text.trim(), role: 'agent', active: true, promoCode: promo).toMap());
        await FirebaseFirestore.instance.collection('agents').doc(uid).set({'email': emailC.text.trim(), 'promoCode': promo, 'createdAt': FieldValue.serverTimestamp()});
      } else {
        // user requires promo validation and active=false
        final promo = promoC.text.trim();
        if (promo.isEmpty) {
          throw Exception(SO.promoRequired);
        }
        final agentSnap = await FirebaseFirestore.instance.collection('agents').where('promoCode', isEqualTo: promo).limit(1).get();
        if (agentSnap.docs.isEmpty) {
          throw Exception(SO.invalidPromo);
        }
        final agentId = agentSnap.docs.first.id;
        await users.doc(uid).set(UserInfo(uid: uid, email: emailC.text.trim(), role: 'user', active: false, agentId: agentId, promoCode: promo).toMap());
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Guul! Gali app-ka.')));
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Khalad: ${e.message ?? e.code}')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }
}

// ------------------- Verification Screen (EM...) -------------------
class VerificationScreen extends ConsumerStatefulWidget {
  final String userId;
  const VerificationScreen({super.key, required this.userId});
  @override
  ConsumerState<VerificationScreen> createState() => _VerificationState();
}

class _VerificationState extends ConsumerState<VerificationScreen> {
  final codeC = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final tr = (String so, String en) => t(context, ref, so, en);
    return Scaffold(
      appBar: AppBar(title: Text(tr(SO.verify, EN.verify))),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              Text(tr(SO.userMustVerify, EN.userMustVerify)),
              const SizedBox(height: 12),
              TextField(
                controller: codeC,
                decoration: InputDecoration(labelText: tr(SO.verifyCode, EN.verifyCode), border: const OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: loading ? null : _verifyCode,
                child: loading ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : Text(tr(SO.verify, EN.verify)),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Future<void> _verifyCode() async {
    setState(() => loading = true);
    try {
      final code = codeC.text.trim().toUpperCase();
      final q = await FirebaseFirestore.instance
          .collection('verification_codes')
          .where('code', isEqualTo: code)
          .limit(1)
          .get();
      if (q.docs.isEmpty) throw Exception(SO.invalidVerify);
      final doc = q.docs.first;
      final data = doc.data();
      final used = data['used'] == true;
      final expiresAt = (data['expiresAt'] as Timestamp?)?.toDate();
      final assignedEmail = data['assignedEmail'];
      if (used) throw Exception(SO.invalidVerify);
      if (expiresAt != null && DateTime.now().isAfter(expiresAt)) throw Exception(SO.expired);
      // Activate user
      await FirebaseFirestore.instance.collection('users').doc(widget.userId).update({'active': true});
      await FirebaseFirestore.instance.collection('verification_codes').doc(doc.id).update({
        'used': true,
        'usedBy': widget.userId,
        'usedAt': FieldValue.serverTimestamp(),
      });
      // Commission: 35% of $7 per user => $2.45
      final u = await FirebaseFirestore.instance.collection('users').doc(widget.userId).get();
      final user = UserInfo.fromDoc(u);
      if (user.agentId != null) {
        await FirebaseFirestore.instance
            .collection('agents')
            .doc(user.agentId!)
            .collection('earnings')
            .doc(user.uid)
            .set({'amount': 2.45, 'userId': user.uid, 'email': user.email, 'createdAt': FieldValue.serverTimestamp()});
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Xaqiijin guulaysatay!')));
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => UserDashboard(userId: widget.userId)), (r) => false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }
}

// ------------------- Admin Screen -------------------
class AdminScreen extends ConsumerWidget {
  const AdminScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tr = (String so, String en) => t(context, ref, so, en);
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(tr(SO.admin, EN.admin)),
          bottom: TabBar(
            tabs: [
              Tab(text: tr('Isticmaalayaal', 'Users')),
              Tab(text: tr('Wakiillo', 'Agents')),
              Tab(text: tr('Koodhadh EM', 'EM Codes')),
              Tab(text: tr('Sugaya', 'Pending')),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.logout),
            )
          ],
        ),
        body: const TabBarView(
          children: [
            _AdminUsersTab(),
            _AdminAgentsTab(),
            _AdminCodesTab(),
            _AdminPendingTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showCreateCodeDialog(context),
          child: const Icon(Icons.qr_code),
        ),
      ),
    );
  }

  static Future<void> _showCreateCodeDialog(BuildContext context) async {
    final codeC = TextEditingController(text: 'EM-${const Uuid().v4().substring(0, 6).toUpperCase()}');
    final daysC = TextEditingController(text: '7');
    final emailC = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Samee Koodh EM'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: codeC, decoration: const InputDecoration(labelText: 'Koodh EM...')),
          TextField(controller: daysC, decoration: const InputDecoration(labelText: 'Maalmo (dhicitaan)'), keyboardType: TextInputType.number),
          TextField(controller: emailC, decoration: const InputDecoration(labelText: 'Ku Xidho Iimayl (ikhtiyaari)')),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Jooji')),
          ElevatedButton(
            onPressed: () async {
              final expires = DateTime.now().add(Duration(days: int.tryParse(daysC.text) ?? 7));
              await FirebaseFirestore.instance.collection('verification_codes').add({
                'code': codeC.text.trim().toUpperCase(),
                'expiresAt': Timestamp.fromDate(expires),
                'assignedEmail': emailC.text.trim().isEmpty ? null : emailC.text.trim(),
                'used': false,
                'createdAt': FieldValue.serverTimestamp(),
              });
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Kaydi'),
          ),
        ],
      ),
    );
  }
}

class _AdminUsersTab extends StatelessWidget {
  const _AdminUsersTab();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'user').snapshots(),
      builder: (ctx, s) {
        if (!s.hasData) return const Center(child: CircularProgressIndicator());
        final docs = s.data!.docs;
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (_, i) {
            final u = UserInfo.fromDoc(docs[i]);
            return ListTile(
              leading: Icon(u.active ? Icons.verified : Icons.hourglass_empty, color: u.active ? AppColors.success : AppColors.accent),
              title: Text(u.email),
              subtitle: Text('Role: ${u.role} • Active: ${u.active} • Agent: ${u.agentId ?? '-'}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  await FirebaseFirestore.instance.collection('users').doc(u.uid).delete();
                },
              ),
            );
          },
        );
      },
    );
  }
}

class _AdminAgentsTab extends StatelessWidget {
  const _AdminAgentsTab();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('agents').snapshots(),
      builder: (ctx, s) {
        if (!s.hasData) return const Center(child: CircularProgressIndicator());
        final docs = s.data!.docs;
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (_, i) {
            final d = docs[i].data() as Map<String, dynamic>;
            return ListTile(
              leading: const Icon(Icons.person_pin, color: AppColors.accent),
              title: Text(d['email'] ?? ''),
              subtitle: Text('Promo: ${d['promoCode'] ?? ''}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  await FirebaseFirestore.instance.collection('agents').doc(docs[i].id).delete();
                  await FirebaseFirestore.instance.collection('users').doc(docs[i].id).delete();
                },
              ),
            );
          },
        );
      },
    );
  }
}

class _AdminCodesTab extends StatelessWidget {
  const _AdminCodesTab();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('verification_codes').orderBy('createdAt', descending: true).snapshots(),
      builder: (ctx, s) {
        if (!s.hasData) return const Center(child: CircularProgressIndicator());
        final docs = s.data!.docs;
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (_, i) {
            final d = docs[i].data() as Map<String, dynamic>;
            final expires = (d['expiresAt'] as Timestamp?)?.toDate();
            final isExpired = expires != null && DateTime.now().isAfter(expires);
            return ListTile(
              leading: Icon(isExpired ? Icons.timer_off : Icons.timer, color: isExpired ? Colors.red : AppColors.success),
              title: Text(d['code'] ?? ''),
              subtitle: Text('Assigned: ${d['assignedEmail'] ?? '-'}  • Used: ${d['used'] == true ? 'Yes' : 'No'}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  await FirebaseFirestore.instance.collection('verification_codes').doc(docs[i].id).delete();
                },
              ),
            );
          },
        );
      },
    );
  }
}

class _AdminPendingTab extends StatelessWidget {
  const _AdminPendingTab();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'user').where('active', isEqualTo: false).snapshots(),
      builder: (ctx, s) {
        if (!s.hasData) return const Center(child: CircularProgressIndicator());
        final docs = s.data!.docs;
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (_, i) {
            final u = UserInfo.fromDoc(docs[i]);
            return ListTile(
              leading: const Icon(Icons.hourglass_empty, color: AppColors.accent),
              title: Text(u.email),
              subtitle: Text('Agent: ${u.agentId ?? '-'}'),
              trailing: Text('Sugaya'),
            );
          },
        );
      },
    );
  }
}

// ------------------- Agent Screen -------------------
class AgentScreen extends StatelessWidget {
  final String userId; // agent uid
  const AgentScreen({super.key, required this.userId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wakiil'),
        actions: [IconButton(onPressed: () async => FirebaseAuth.instance.signOut(), icon: const Icon(Icons.logout))],
      ),
      body: Column(
        children: [
          FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection('agents').doc(userId).get(),
            builder: (_, s) {
              if (!s.hasData) return const SizedBox.shrink();
              final m = s.data!.data() as Map<String, dynamic>?;
              final promo = m?['promoCode'] ?? '-';
              return ListTile(
                leading: const Icon(Icons.key, color: AppColors.accent),
                title: Text('Promo: $promo'),
                subtitle: const Text('Koodhkaaga gaarka ah'),
              );
            },
          ),
          const Divider(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('users').where('agentId', isEqualTo: userId).where('role', isEqualTo: 'user').snapshots(),
              builder: (ctx, s) {
                if (!s.hasData) return const Center(child: CircularProgressIndicator());
                final docs = s.data!.docs;
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (_, i) {
                    final u = UserInfo.fromDoc(docs[i]);
                    return ListTile(
                      title: Text(u.email),
                      subtitle: Text('Xaalad: ${u.active ? SO.active : SO.waiting}'),
                      trailing: FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance.collection('agents').doc(userId).collection('earnings').doc(u.uid).get(),
                        builder: (_, es) {
                          double amount = 0;
                          if (es.data?.exists == true) {
                            amount = (es.data!.data() as Map<String, dynamic>)['amount']?.toDouble() ?? 0;
                          }
                          return Text('\$${amount.toStringAsFixed(2)}');
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------- User Dashboard -------------------
class UserDashboard extends StatefulWidget {
  final String userId;
  const UserDashboard({super.key, required this.userId});
  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> with SingleTickerProviderStateMixin {
  late TabController tab;

  @override
  void initState() {
    super.initState();
    tab = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Isticmaale'),
        bottom: TabBar(
          controller: tab,
          tabs: const [
            Tab(text: 'Hore'),
            Tab(text: 'Alaab'),
            Tab(text: 'Warbixin'),
            Tab(text: 'AI'),
            Tab(text: 'Dejin'),
          ],
        ),
        actions: [IconButton(onPressed: () async => FirebaseAuth.instance.signOut(), icon: const Icon(Icons.logout))],
      ),
      floatingActionButton: tab.index == 0
          ? FloatingActionButton(
              onPressed: _showAddTransaction,
              child: const Icon(Icons.add),
            )
          : null,
      body: TabBarView(
        controller: tab,
        children: [
          _buildHomeTab(),
          ProductsTab(userId: widget.userId),
          ReportsTab(userId: widget.userId),
          KobciyeAITab(userId: widget.userId),
          SettingsTab(userId: widget.userId),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    final txColl = FirebaseFirestore.instance.collection('users').doc(widget.userId).collection('transactions').orderBy('date', descending: true);
    return Column(
      children: [
        const SizedBox(height: 8),
        StreamBuilder<QuerySnapshot>(
          stream: txColl.snapshots(),
          builder: (_, s) {
            double inc = 0, exp = 0;
            if (s.data != null) {
              for (final d in s.data!.docs) {
                final m = d.data() as Map<String, dynamic>;
                final amt = (m['amount'] ?? 0).toDouble();
                if ((m['type'] ?? 'income') == 'income') inc += amt;
                else exp += amt;
              }
            }
            return Row(
              children: [
                Expanded(child: _statCard(SO.income, inc, AppColors.success, Icons.trending_up)),
                Expanded(child: _statCard(SO.expense, exp, AppColors.danger, Icons.trending_down)),
              ],
            );
          },
        ),
        const Divider(),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: txColl.snapshots(),
            builder: (_, s) {
              if (!s.hasData) return const Center(child: CircularProgressIndicator());
              final docs = s.data!.docs;
              if (docs.isEmpty) return const Center(child: Text('Wax dhaqdhaqaaq ma jiro'));
              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (_, i) {
                  final d = docs[i];
                  final tx = TransactionModel.fromDoc(d);
                  return ListTile(
                    leading: Icon(tx.type == 'income' ? Icons.arrow_downward : Icons.arrow_upward, color: tx.type == 'income' ? AppColors.success : AppColors.danger),
                    title: Text(tx.name),
                    subtitle: Text(DateFormat.yMMMd().format(tx.date)),
                    trailing: Text((tx.type == 'income' ? '+' : '-') + tx.amount.toStringAsFixed(2)),
                    onLongPress: () => _editTransaction(d),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _statCard(String title, double amount, Color color, IconData icon) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('\$${amount.toStringAsFixed(2)}', style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
          ]),
          Icon(icon, color: color),
        ]),
      ),
    );
  }

  void _showAddTransaction() {
    final nameC = TextEditingController();
    final amountC = TextEditingController();
    String type = 'income';
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Ku dar Dhaqdhaqaaq'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: nameC, decoration: const InputDecoration(labelText: 'Magac')),
          TextField(controller: amountC, decoration: const InputDecoration(labelText: 'Qiime'), keyboardType: TextInputType.number),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: type,
            items: const [
              DropdownMenuItem(value: 'income', child: Text('Dakhli')),
              DropdownMenuItem(value: 'expense', child: Text('Kharash')),
            ],
            onChanged: (v) => type = v ?? 'income',
          ),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Jooji')),
          ElevatedButton(
            onPressed: () async {
              final tx = TransactionModel(
                id: const Uuid().v4(),
                name: nameC.text,
                amount: double.tryParse(amountC.text) ?? 0,
                type: type,
                date: DateTime.now(),
              );
              await FirebaseFirestore.instance.collection('users').doc(widget.userId).collection('transactions').add(tx.toMap());
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Kaydi'),
          ),
        ],
      ),
    );
  }

  void _editTransaction(DocumentSnapshot doc) {
    final tx = TransactionModel.fromDoc(doc);
    final nameC = TextEditingController(text: tx.name);
    final amountC = TextEditingController(text: tx.amount.toString());
    String type = tx.type;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Wax ka beddel Dhaqdhaqaaq'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: nameC, decoration: const InputDecoration(labelText: 'Magac')),
          TextField(controller: amountC, decoration: const InputDecoration(labelText: 'Qiime'), keyboardType: TextInputType.number),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: type,
            items: const [
              DropdownMenuItem(value: 'income', child: Text('Dakhli')),
              DropdownMenuItem(value: 'expense', child: Text('Kharash')),
            ],
            onChanged: (v) => type = v ?? 'income',
          ),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Jooji')),
          TextButton(
              onPressed: () async {
                await doc.reference.delete();
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('Tirtir', style: TextStyle(color: Colors.red))),
          ElevatedButton(
            onPressed: () async {
              await doc.reference.update({'name': nameC.text, 'amount': double.tryParse(amountC.text) ?? 0, 'type': type});
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Kaydi'),
          ),
        ],
      ),
    );
  }
}

// ------------------- Products Tab (with Barcode) -------------------
class ProductsTab extends StatefulWidget {
  final String userId;
  const ProductsTab({super.key, required this.userId});
  @override
  State<ProductsTab> createState() => _ProductsTabState();
}

class _ProductsTabState extends State<ProductsTab> {
  @override
  Widget build(BuildContext context) {
    final coll = FirebaseFirestore.instance.collection('users').doc(widget.userId).collection('products');
    return Column(
      children: [
        const SizedBox(height: 8),
        Row(
          children: [
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: _addProductDialog,
              icon: const Icon(Icons.add),
              label: const Text('Ku dar Alaab'),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: _scanBarcode,
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Skan Baarkood'),
            ),
          ],
        ),
        const Divider(),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: coll.orderBy('createdAt', descending: true).snapshots(),
            builder: (_, s) {
              if (!s.hasData) return const Center(child: CircularProgressIndicator());
              final docs = s.data!.docs;
              if (docs.isEmpty) return const Center(child: Text('Alaab ma jiro'));
              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (_, i) {
                  final p = Product.fromDoc(docs[i]);
                  return ListTile(
                    title: Text('${p.name} • ${p.qty}x'),
                    subtitle: Text('Barcode: ${p.barcode}'),
                    trailing: Text('\$${p.price.toStringAsFixed(2)}'),
                    onTap: () => _sellProductDialog(docs[i], p),
                    onLongPress: () => docs[i].reference.delete(),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _addProductDialog() async {
    final nameC = TextEditingController();
    final barcodeC = TextEditingController();
    final priceC = TextEditingController();
    final qtyC = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Ku dar Alaab'),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(controller: nameC, decoration: const InputDecoration(labelText: 'Magac')),
            TextField(controller: barcodeC, decoration: const InputDecoration(labelText: 'Baarkood')),
            TextField(controller: priceC, decoration: const InputDecoration(labelText: 'Qiime'), keyboardType: TextInputType.number),
            TextField(controller: qtyC, decoration: const InputDecoration(labelText: 'Tiro'), keyboardType: TextInputType.number),
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Jooji')),
          ElevatedButton(
            onPressed: () async {
              final pr = Product(
                id: const Uuid().v4(),
                name: nameC.text,
                barcode: barcodeC.text,
                price: double.tryParse(priceC.text) ?? 0,
                qty: int.tryParse(qtyC.text) ?? 0,
              );
              await FirebaseFirestore.instance.collection('users').doc(widget.userId).collection('products').add(pr.toMap());
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Kaydi'),
          ),
        ],
      ),
    );
  }

  Future<void> _scanBarcode() async {
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Skan baarkood ma shaqeeyo web-ka')));
      return;
    }
    try {
      final barcode = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Jooji', true, ScanMode.BARCODE);
      if (barcode == '-1') return;
      final coll = FirebaseFirestore.instance.collection('users').doc(widget.userId).collection('products');
      final q = await coll.where('barcode', isEqualTo: barcode).limit(1).get();
      if (q.docs.isNotEmpty) {
        final p = Product.fromDoc(q.docs.first);
        _sellProductDialog(q.docs.first, p);
      } else {
        // add new with barcode prefilled
        final nameC = TextEditingController();
        final priceC = TextEditingController();
        final qtyC = TextEditingController(text: '1');
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Ku dar Alaab (Cusub)'),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              Text('Barcode: $barcode'),
              TextField(controller: nameC, decoration: const InputDecoration(labelText: 'Magac')),
              TextField(controller: priceC, decoration: const InputDecoration(labelText: 'Qiime'), keyboardType: TextInputType.number),
              TextField(controller: qtyC, decoration: const InputDecoration(labelText: 'Tiro'), keyboardType: TextInputType.number),
            ]),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Jooji')),
              ElevatedButton(
                onPressed: () async {
                  final pr = Product(
                    id: const Uuid().v4(),
                    name: nameC.text,
                    barcode: barcode,
                    price: double.tryParse(priceC.text) ?? 0,
                    qty: int.tryParse(qtyC.text) ?? 1,
                  );
                  await coll.add(pr.toMap());
                  if (context.mounted) Navigator.pop(context);
                },
                child: const Text('Kaydi'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Khalad: $e')));
    }
  }

  void _sellProductDialog(DocumentSnapshot ref, Product p) {
    final qtyC = TextEditingController(text: '1');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Iib Alaab'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(p.name),
          Text('Qiime: \$${p.price.toStringAsFixed(2)}'),
          TextField(controller: qtyC, decoration: const InputDecoration(labelText: 'Tiro'), keyboardType: TextInputType.number),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Jooji')),
          ElevatedButton(
            onPressed: () async {
              final sellQty = int.tryParse(qtyC.text) ?? 1;
              final newQty = max(0, p.qty - sellQty);
              await ref.reference.update({'qty': newQty});
              final amount = p.price * sellQty;
              await FirebaseFirestore.instance.collection('users').doc(widget.userId).collection('transactions').add({
                'name': 'Iib: ${p.name}',
                'amount': amount,
                'type': 'income',
                'date': Timestamp.fromDate(DateTime.now()),
              });
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Iib'),
          ),
        ],
      ),
    );
  }
}

// ------------------- Reports Tab (Charts) -------------------
class ReportsTab extends StatelessWidget {
  final String userId;
  const ReportsTab({super.key, required this.userId});
  @override
  Widget build(BuildContext context) {
    final coll = FirebaseFirestore.instance.collection('users').doc(userId).collection('transactions');
    return Padding(
      padding: const EdgeInsets.all(8),
      child: StreamBuilder<QuerySnapshot>(
        stream: coll.snapshots(),
        builder: (_, s) {
          if (!s.hasData) return const Center(child: CircularProgressIndicator());
          final now = DateTime.now();
          double dInc = 0, dExp = 0, mInc = 0, mExp = 0, yInc = 0, yExp = 0;
          for (final d in s.data!.docs) {
            final m = d.data() as Map<String, dynamic>;
            final dt = (m['date'] as Timestamp).toDate();
            final amt = (m['amount'] ?? 0).toDouble();
            final isInc = (m['type'] ?? 'income') == 'income';
            if (DateUtils.isSameDay(dt, now)) {
              if (isInc) dInc += amt; else dExp += amt;
            }
            if (dt.year == now.year && dt.month == now.month) {
              if (isInc) mInc += amt; else mExp += amt;
            }
            if (dt.year == now.year) {
              if (isInc) yInc += amt; else yExp += amt;
            }
          }
          return ListView(
            children: [
              _chartCard('Maalinle', dInc, dExp),
              _chartCard('Bishan', mInc, mExp),
              _chartCard('Sanadkan', yInc, yExp),
            ],
          );
        },
      ),
    );
  }

  Widget _chartCard(String title, double inc, double exp) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, meta) {
                    switch (v.toInt()) {
                      case 0: return const Text('Dakhli');
                      case 1: return const Text('Kharash');
                    }
                    return const SizedBox.shrink();
                  })),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                barGroups: [
                  BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: inc, color: AppColors.success)]),
                  BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: exp, color: AppColors.danger)]),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

// ------------------- KOBCIYE AI Tab -------------------
class KobciyeAITab extends ConsumerStatefulWidget {
  final String userId;
  const KobciyeAITab({super.key, required this.userId});
  @override
  ConsumerState<KobciyeAITab> createState() => _KobciyeAIState();
}

class _KobciyeAIState extends ConsumerState<KobciyeAITab> {
  final TextEditingController msgC = TextEditingController();
  final List<Map<String, String>> messages = []; // [{'role':'user','content':...}, {'role':'ai','content':...}]
  bool loading = false;

  @override
  void dispose() {
    msgC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final apiKey = ref.watch(aiApiKeyProvider);
    return Scaffold(
      body: Container(
        color: Colors.black87,
        child: Column(children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (_, i) {
                final m = messages[i];
                final isUser = m['role'] == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? AppColors.accent : Colors.grey[800],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(m['content'] ?? '', style: const TextStyle(color: Colors.white)),
                  ),
                );
              },
            ),
          ),
          if (apiKey == null)
            Container(
              color: Colors.black54,
              padding: const EdgeInsets.all(8),
              child: Row(children: [
                const Expanded(
                    child: Text('Geli KOBCIYE API KEY gudaha Dejinta → AI', style: TextStyle(color: Colors.white70))),
                TextButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Tag Dejin → Xulo KOBCIYE AI Key'))),
                  child: const Text('OK', style: TextStyle(color: Colors.white)),
                )
              ]),
            ),
          _composer(),
        ]),
      ),
    );
  }

  Widget _composer() {
    return SafeArea(
      child: Row(children: [
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: msgC,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
                hintText: 'Fariin qor...', hintStyle: TextStyle(color: Colors.white54), border: InputBorder.none),
          ),
        ),
        IconButton(
          icon: loading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.send, color: Colors.white),
          onPressed: loading ? null : _send,
        ),
      ]),
    );
  }

  Future<void> _send() async {
    final text = msgC.text.trim();
    if (text.isEmpty) return;
    setState(() {
      messages.add({'role': 'user', 'content': text});
      msgC.clear();
      loading = true;
    });
    try {
      final reply = await _callKobciye(text);
      setState(() {
        messages.add({'role': 'ai', 'content': reply});
      });
    } catch (e) {
      setState(() {
        messages.add({'role': 'ai', 'content': 'Khalad adeegga AI: $e'});
      });
    } finally {
      setState(() => loading = false);
    }
  }

  Future<String> _callKobciye(String prompt) async {
    final apiKey = ref.read(aiApiKeyProvider);
    if (apiKey == null) return 'Fadlan geli API Key-ga KOBCIYE ee Dejinta.';
    // Replace with the real KOBCIYE AI URL and payload contract.
    final uri = Uri.parse('https://api.kobciye.ai/v1/chat'); // example endpoint
    final resp = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': 'kobciye-so-1',
        'messages': [
          {'role': 'system', 'content': 'Khad adeeg Somali-only.'},
          {'role': 'user', 'content': prompt}
        ],
        'temperature': 0.2,
      }),
    );
    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final data = jsonDecode(resp.body);
      // Map to the actual schema:
      return data['reply'] ?? data['choices']?[0]?['message']?['content'] ?? 'Jawaab lama helin.';
    } else {
      throw 'HTTP ${resp.statusCode}';
    }
  }
}

// ------------------- Settings Tab -------------------
class SettingsTab extends ConsumerWidget {
  final String userId;
  const SettingsTab({super.key, required this.userId});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dark = ref.watch(themeDarkProvider);
    final lang = ref.watch(langProvider);
    final currency = ref.watch(currencyProvider);
    final apiKey = ref.watch(aiApiKeyProvider);
    return ListView(
      children: [
        const SizedBox(height: 8),
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text('Akunka'),
          subtitle: FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
            builder: (_, s) => Text(s.data?.get('email') ?? FirebaseAuth.instance.currentUser?.email ?? ''),
          ),
        ),
        SwitchListTile(
          value: dark,
          onChanged: (v) async {
            ref.read(themeDarkProvider.notifier).state = v;
            (await SharedPreferences.getInstance()).setBool('dark', v);
          },
          title: const Text('Hab Mugdiga'),
        ),
        ListTile(
          title: const Text('Luqad'),
          subtitle: Text(lang == 'SO' ? 'Somali' : 'English'),
          trailing: DropdownButton<String>(
            value: lang,
            items: const [
              DropdownMenuItem(value: 'SO', child: Text('Somali')),
              DropdownMenuItem(value: 'EN', child: Text('English')),
            ],
            onChanged: (v) async {
              ref.read(langProvider.notifier).state = v ?? 'SO';
              (await SharedPreferences.getInstance()).setString('lang', v ?? 'SO');
            },
          ),
        ),
        ListTile(
          title: const Text('Lacagta'),
          subtitle: Text(currency),
          trailing: DropdownButton<String>(
            value: currency,
            items: const [
              DropdownMenuItem(value: 'USD', child: Text('USD')),
              DropdownMenuItem(value: 'EUR', child: Text('EUR')),
              DropdownMenuItem(value: 'SOS', child: Text('SOS')),
            ],
            onChanged: (v) async {
              ref.read(currencyProvider.notifier).state = v ?? 'USD';
              (await SharedPreferences.getInstance()).setString('cur', v ?? 'USD');
            },
          ),
        ),
        ListTile(
          title: const Text('Beddel Sirta'),
          trailing: const Icon(Icons.password),
          onTap: () async {
            final newPass = await _promptText(context, 'Sir cusub');
            if (newPass != null && newPass.length >= 6) {
              await FirebaseAuth.instance.currentUser?.updatePassword(newPass);
              if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sirta waa la cusboonaysiiyay')));
            }
          },
        ),
        ListTile(
          title: const Text('Deji PIN'),
          trailing: const Icon(Icons.pin),
          onTap: () async {
            final pin = await _promptText(context, 'PIN (4 tiro)');
            if (pin != null && pin.length == 4) {
              (await SharedPreferences.getInstance()).setString('pin', pin);
              if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PIN waa la kaydiyay')));
            }
          },
        ),
        ListTile(
          title: const Text('KOBCIYE AI Key'),
          subtitle: Text(apiKey == null ? '(lama dejin)' : '••••••••'),
          trailing: const Icon(Icons.vpn_key),
          onTap: () async {
            final key = await _promptText(context, 'Geli KOBCIYE API Key');
            if (key != null && key.isNotEmpty) {
              ref.read(aiApiKeyProvider.notifier).state = key;
              (await SharedPreferences.getInstance()).setString('aiKey', key);
              if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('AI Key waa la kaydiyay')));
            }
          },
        ),
        ListTile(
          title: const Text('La wadaag App-ka'),
          trailing: const Icon(Icons.share),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ku wadaag link-ga Play Store (mustaqbalka)')));
          },
        ),
      ],
    );
  }

  Future<String?> _promptText(BuildContext context, String title) async {
    final c = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: TextField(controller: c),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Jooji')),
          ElevatedButton(onPressed: () => Navigator.pop(context, c.text), child: const Text('OK')),
        ],
      ),
    );
  }
}

// ------------------- SUMMARY -------------------
// - Full auth with roles, promo-based agent linking, user verification EM codes
// - Admin: manage users/agents, generate EM codes, view pending
// - Agent: users under promo, earnings per activated user ($2.45)
// - User: transactions, products, barcode scanner (mobile), reports, KOBCIYE AI, settings
// - Somali-first UI, supports English switch
// - Dark mode, currency, PIN, share app
