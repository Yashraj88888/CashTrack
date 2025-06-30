import 'package:cashtrack/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SkillupPage(),
    );
  }
}

class SkillupPage extends StatefulWidget {


  const SkillupPage({super.key});

  @override
  State<SkillupPage> createState() => _SkillupPageState();
}

class _SkillupPageState extends State<SkillupPage> {
  int _selectedIndex = 1;
  void _onBottomNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    }
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    }
    // Add more navigation logic for other indices if needed
  }

  void _showFlipDialog(
      BuildContext context,
      Color color,
      String text,
      String question,
      String answer,
      ) {
    showDialog(
      context: context,
      builder: (_) => Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          height: MediaQuery.of(context).size.height * 0.6,
          child: FlipCard(
            front: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/chippyquestion.png',
                      height: 100,
                      width: 100,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      question,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            back: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Background image
                  Opacity(
                    opacity: 0.4, // value between 0.0 (transparent) and 1.0 (opaque)
                    child: Image.asset(
                      'assets/bg.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),

                  // Semi-transparent overlay (optional for readability)
                  Container(
                    color: Colors.black.withOpacity(0.5),
                  ),

                  // Content (image + text)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Image above the answer text
                        Image.asset(
                          'assets/chippyhappy.png', // Your image above the answer
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          answer,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                            decoration: TextDecoration.none,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        elevation: 2,
        shadowColor: Colors.transparent,
        backgroundColor: const Color(0xFF00CCE7),
        leadingWidth: 90,
        leading: Padding(
          padding: const EdgeInsets.only(left: 2.0),
          child: Image.asset(
            'assets/logo.png',
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        ),
        title: Transform.translate(
          offset: const Offset(-25, -5),
          child: const Text(
            'Skill Up',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 30,
              color: Colors.black,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Transform.translate(
              offset: const Offset(0, -5),
              child: const Icon(
                Icons.account_circle,
                size: 50,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section 1: Tip of the Day
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    ClipOval(
                      child: Image.asset(
                        'assets/chippy.png',
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Tip of the Day',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade800,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 8,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lightbulb,
                        color: Colors.yellow.shade700,
                        size: 32,
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          'Always track your expenses daily to avoid overspending.',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Section 2: Car Affordability
              _SectionHeader(
                icon: Icons.directions_car,
                label: 'Car Affordability',
              ),
              const SizedBox(height: 10),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.0,
                children: List.generate(4, (index) {
                  final questions = [
                    'What is 20 / 40 / 10 Rule for Buying a Car?',
                    'Should I buy or lease?',
                    'What is car depreciation?',
                    'Best time to buy a car?'
                  ];
                  final answers = [
                    'The 20/40/10 rule is a smart budgeting guide for buying a car. It suggests paying 20% upfront, keeping your car loan EMI under 10% of your monthly income, and ensuring total car expenses (including fuel and insurance) stay below 40% of your income. This helps you avoid financial stress while owning a car.',
                    'Buying is long-term ownership, leasing is short-term use.',
                    'Depreciation is the loss in value of the car over time.',
                    'Festive seasons and year-end sales are ideal.'
                  ];
                  return GestureDetector(
                    onTap: () => _showFlipDialog(
                      context,
                      Colors.blue,
                      'Feature #${index + 1}',
                      questions[index],
                      answers[index],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/bluecard.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
              // Section 3: Saving Rules
              _SectionHeader(
                icon: Icons.savings,
                label: 'Saving Rules',
              ),
              const SizedBox(height: 10),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.0,
                children: List.generate(4, (index) {
                  final questions = [
                    'What is the 50/30/20 rule?',
                    'Why save emergency funds?',
                    'What is compound interest?',
                    'How to track expenses?'
                  ];
                  final answers = [
                    '50% needs, 30% wants, 20% savings.',
                    'For unexpected expenses like medical bills.',
                    'Interest on interest earned over time.',
                    'Use budgeting apps or notebooks daily.'
                  ];
                  return GestureDetector(
                    onTap: () => _showFlipDialog(
                      context,
                      Colors.green,
                      'Rule #${index + 1}',
                      questions[index],
                      answers[index],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/greencard.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFF00CCE7),
        unselectedItemColor: Color(0xFF949FA5),
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: _onBottomNavTapped,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.school), label: 'SkillUp'),
          BottomNavigationBarItem(
              icon: Icon(Icons.swap_horiz), label: 'Transactions'),
          BottomNavigationBarItem(
              icon: Icon(Icons.group), label: 'Splits'),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SectionHeader({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue, size: 32),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 26,
            color: Colors.blue,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}