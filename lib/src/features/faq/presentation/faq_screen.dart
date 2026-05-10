import 'package:flutter/material.dart';
import 'package:registry/src/common/app_theme.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  // Hardcoded FAQ data
  static const List<Map<String, String>> _faqs = [
    {
      "question": "How long does it take to resolve a complaint?",
      "answer":
          "Typically, complaints are reviewed within 3-5 working days. Complex cases may take longer, but you will be updated via admin replies on the complaint details page.",
    },
    {
      "question": "Can I upload evidence for my complaint?",
      "answer":
          "Yes. While registering a complaint, you can attach a photo directly from your camera or gallery. This evidence helps the university investigate your issue more effectively.",
    },
    {
      "question": "How can I track my complaint?",
      "answer":
          "Go to 'View Your Complaints' from the home screen. Tap on any complaint to see its full details, current status, and any replies from the administration.",
    },
    {
      "question": "What do the different statuses mean?",
      "answer":
          "Pending: Your complaint has been submitted but not yet reviewed.\nUnder Review: The administration is currently investigating.\nResolved: The issue has been addressed.\nRejected: The complaint was reviewed but determined to be invalid or unsupported.",
    },
    {
      "question": "Can I submit a complaint anonymously?",
      "answer":
          "No. All complaints require your student ID and name, which are automatically included when you submit. This ensures accountability and helps the administration follow up if needed.",
    },
    {
      "question": "What should I do if my complaint is rejected?",
      "answer":
          "You may submit a new complaint with more detailed information or contact your department's grievance officer directly. The university is committed to fair resolution of all issues.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(title: const Text('FAQs')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          // Header
          Center(
            child: Column(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.help_outline_rounded,
                    size: 40,
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Frequently Asked Questions',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Find answers to common questions about the complaint process.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // FAQ tiles
          ..._faqs.asMap().entries.map((entry) {
            final int index = entry.key;
            final Map<String, String> faq = entry.value;
            return _FaqTile(
              question: faq["question"]!,
              answer: faq["answer"]!,
              isLast: index == _faqs.length - 1,
            );
          }),
        ],
      ),
    );
  }
}

class _FaqTile extends StatefulWidget {
  final String question;
  final String answer;
  final bool isLast;

  const _FaqTile({
    required this.question,
    required this.answer,
    required this.isLast,
  });

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: widget.isLast ? 0 : 16),
      child: GestureDetector(
        onTap: _toggle,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Question row
              Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: _isExpanded
                            ? AppTheme.secondary.withOpacity(0.15)
                            : AppTheme.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isExpanded ? Icons.remove : Icons.add,
                        size: 20,
                        color: _isExpanded
                            ? AppTheme.secondary
                            : AppTheme.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        widget.question,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _isExpanded
                              ? AppTheme.primary
                              : AppTheme.onSurface,
                        ),
                      ),
                    ),
                    AnimatedRotation(
                      turns: _isExpanded ? 0.250 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        Icons.chevron_right,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),

              // Answer (expandable)
              SizeTransition(
                sizeFactor: _expandAnimation,
                axisAlignment: -1.0,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(height: 1, color: Colors.grey.shade200),
                      const SizedBox(height: 14),
                      Text(
                        widget.answer,
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.5,
                          color: Colors.grey.shade700,
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
}
