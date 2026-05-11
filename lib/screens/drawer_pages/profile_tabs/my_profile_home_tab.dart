import 'package:flutter/material.dart';

class MyProfileHomeTab extends StatefulWidget {
  const MyProfileHomeTab({super.key});

  @override
  State<MyProfileHomeTab> createState() => _MyProfileHomeTabState();
}

class _MyProfileHomeTabState extends State<MyProfileHomeTab> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 820;
        return Column(
          children: [
            if (isCompact)
              const Column(
                children: [
                  _ProfileCard(),
                  SizedBox(height: 12),
                  _TraitsTable(),
                ],
              )
            else
              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 4, child: _ProfileCard()),
                  SizedBox(width: 12),
                  Expanded(flex: 6, child: _TraitsTable()),
                ],
              ),
            const SizedBox(height: 14),
            const _ProfileSummaryPanels(),
          ],
        );
      },
    );
  }
}

class _ProfileCard extends StatefulWidget {
  const _ProfileCard();

  @override
  State<_ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<_ProfileCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1C0027), Color(0xFF32003E)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/images/notification-image4.jpg',
              height: 130,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'davidbrown',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '21 Years',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 11),
          ),
          Text(
            'Male | Female',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 11),
          ),
          Text(
            'Jaipur, Rajasthan, India',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 11),
          ),
          const SizedBox(height: 8),
          const Text(
            'Swingers\nHookUps/Meetups',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 20,
              height: 1.15,
            ),
          ),
        ],
      ),
    );
  }
}

class _TraitsTable extends StatefulWidget {
  const _TraitsTable();

  static const List<_Trait> _traits = [
    _Trait(label: 'Age', mine: '21 Years', match: '20 Years'),
    _Trait(label: 'Tattoos', mine: 'One', match: 'One'),
    _Trait(label: 'Body Hair', mine: 'Bikini', match: 'Arm, Chest'),
    _Trait(label: 'Weight', mine: '65 KG', match: '65 KG'),
    _Trait(label: 'Height', mine: '4.6 FT', match: '5.7 FT'),
    _Trait(label: 'Smoking', mine: 'Yes', match: 'No'),
    _Trait(label: 'Drinking', mine: 'Yes', match: 'Occasionally'),
    _Trait(label: 'Body Type', mine: 'BBW', match: 'Athletic'),
    _Trait(label: 'Languages', mine: 'English, Hindi', match: 'English'),
  ];

  @override
  State<_TraitsTable> createState() => _TraitsTableState();
}

class _TraitsTableState extends State<_TraitsTable> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: _TraitsTable._traits.map((trait) => _TraitRow(trait: trait)).toList(),
    );
  }
}

class _TraitRow extends StatelessWidget {
  const _TraitRow({required this.trait});

  final _Trait trait;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF180024), Color(0xFF3D0053)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                trait.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: _ConversationValue(
              text: trait.mine,
              avatarIcon: Icons.person,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: _ConversationValue(
              text: trait.match,
              avatarIcon: Icons.person_2,
            ),
          ),
        ],
      ),
    );
  }
}

class _ConversationValue extends StatefulWidget {
  const _ConversationValue({
    required this.text,
    required this.avatarIcon,
  });

  final String text;
  final IconData avatarIcon;

  @override
  State<_ConversationValue> createState() => _ConversationValueState();
}

class _ConversationValueState extends State<_ConversationValue> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFFEDF5FF), Color(0xFFDCE9FF)],
            ),
            border: Border.all(color: const Color(0xFFBDD1F8)),
          ),
          child: Icon(widget.avatarIcon, size: 16, color: const Color(0xFF3B6CB7)),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Container(
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE6DFF0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              widget.text,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Trait {
  const _Trait({
    required this.label,
    required this.mine,
    required this.match,
  });

  final String label;
  final String mine;
  final String match;
}

class _ProfileSummaryPanels extends StatefulWidget {
  const _ProfileSummaryPanels();

  @override
  State<_ProfileSummaryPanels> createState() => _ProfileSummaryPanelsState();
}

class _ProfileSummaryPanelsState extends State<_ProfileSummaryPanels> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 640;
        if (compact) {
          return const Column(
            children: [
              _InfoPanel(
                title: 'About',
                content: 'Open-minded, respectful, and always up for meaningful conversations.',
              ),
              SizedBox(height: 10),
              _InfoPanel(
                title: 'Interests',
                content: 'Music nights, travel meetups, coffee dates, and weekend hangouts.',
              ),
            ],
          );
        }
        return const Row(
          children: [
            Expanded(
              child: _InfoPanel(
                title: 'About',
                content: 'Open-minded, respectful, and always up for meaningful conversations.',
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _InfoPanel(
                title: 'Interests',
                content: 'Music nights, travel meetups, coffee dates, and weekend hangouts.',
              ),
            ),
          ],
        );
      },
    );
  }
}

class _InfoPanel extends StatelessWidget {
  const _InfoPanel({
    required this.title,
    required this.content,
  });

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFBF8FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5DDF2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2F1047),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: TextStyle(
              fontSize: 12,
              height: 1.3,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}
