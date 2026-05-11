import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

// --- STATE ---
class ProfileEditState {
  final bool isProfileDetailsTab;
  final Map<String, bool> swingersOptions;
  final Map<String, bool> hookupOptions;
  final bool isSwingersExpanded;
  final bool isHookupExpanded;
  final String aboutMe;
  final String lookingFor;
  final Map<String, String> partner1;
  final Map<String, String> partner2;
  final List<String> partner1Languages;
  final List<String> partner2Languages;

  const ProfileEditState({
    this.isProfileDetailsTab = false,
    required this.swingersOptions,
    required this.hookupOptions,
    this.isSwingersExpanded = true,
    this.isHookupExpanded = true,
    this.aboutMe = 'About me',
    this.lookingFor = 'Describe what you are looking for...',
    required this.partner1,
    required this.partner2,
    required this.partner1Languages,
    required this.partner2Languages,
  });

  ProfileEditState copyWith({
    bool? isProfileDetailsTab,
    Map<String, bool>? swingersOptions,
    Map<String, bool>? hookupOptions,
    bool? isSwingersExpanded,
    bool? isHookupExpanded,
    String? aboutMe,
    String? lookingFor,
    Map<String, String>? partner1,
    Map<String, String>? partner2,
    List<String>? partner1Languages,
    List<String>? partner2Languages,
  }) {
    return ProfileEditState(
      isProfileDetailsTab: isProfileDetailsTab ?? this.isProfileDetailsTab,
      swingersOptions: swingersOptions ?? this.swingersOptions,
      hookupOptions: hookupOptions ?? this.hookupOptions,
      isSwingersExpanded: isSwingersExpanded ?? this.isSwingersExpanded,
      isHookupExpanded: isHookupExpanded ?? this.isHookupExpanded,
      aboutMe: aboutMe ?? this.aboutMe,
      lookingFor: lookingFor ?? this.lookingFor,
      partner1: partner1 ?? this.partner1,
      partner2: partner2 ?? this.partner2,
      partner1Languages: partner1Languages ?? this.partner1Languages,
      partner2Languages: partner2Languages ?? this.partner2Languages,
    );
  }
}

// --- NOTIFIER ---
class ProfileEditNotifier extends Notifier<ProfileEditState> {
  @override
  ProfileEditState build() {
    return ProfileEditState(
      swingersOptions: {
        'Couple Female/Male': true,
        'Couple Female/Female': true,
        'Couple Male/Male': true,
        'Female': true,
        'Male': true,
        'Transgender': true,
      },
      hookupOptions: {
        'Couple Female/Male': true,
        'Couple Female/Female': true,
        'Couple Male/Male': true,
        'Female': true,
        'Male': true,
        'Transgender': false,
      },
      partner1: {
        'dateOfBirth': '17/06/2004',
        'height': "4'6",
        'weight': '65',
        'bodyType': 'BBW',
        'ethnic': 'Italian',
        'sexuality': 'Straight',
        'orientation': "I'm not comfortable sharing that.",
        'tattoos': 'One',
        'piercings': 'No',
        'smoking': 'Yes',
        'drinking': 'Yes',
        'bodyHair': 'Bikini',
        'looks': "I'm not comfortable sharing that.",
        'intelligence': 'Very Important',
        'circumcised': 'Yes',
      },
      partner2: {
        'dateOfBirth': '03/12/2007',
        'height': "5'7",
        'weight': '65',
        'bodyType': 'Athletic',
        'ethnic': 'German',
        'sexuality': 'Straight',
        'orientation': 'Swinger',
        'tattoos': 'One',
        'piercings': 'Yes',
        'smoking': 'No',
        'drinking': 'Occasionally',
        'bodyHair': 'Arm, Chest',
        'looks': "I'm not comfortable sharing that.",
        'intelligence': 'Low Importance',
        'circumcised': "I'm not comfortable sharing that.",
      },
      partner1Languages: ['English'],
      partner2Languages: ['English'],
    );
  }

  void toggleProfileTab(bool isProfile) {
    state = state.copyWith(isProfileDetailsTab: isProfile);
  }

  void toggleSwingersExpanded() {
    state = state.copyWith(isSwingersExpanded: !state.isSwingersExpanded);
  }

  void toggleHookupExpanded() {
    state = state.copyWith(isHookupExpanded: !state.isHookupExpanded);
  }

  void updateSwingersOption(String label, bool value) {
    final newOptions = Map<String, bool>.from(state.swingersOptions);
    newOptions[label] = value;
    state = state.copyWith(swingersOptions: newOptions);
  }

  void updateHookupOption(String label, bool value) {
    final newOptions = Map<String, bool>.from(state.hookupOptions);
    newOptions[label] = value;
    state = state.copyWith(hookupOptions: newOptions);
  }

  void updateAboutMe(String value) {
    state = state.copyWith(aboutMe: value);
  }

  void updateLookingFor(String value) {
    state = state.copyWith(lookingFor: value);
  }

  void updatePartner1(String key, String value) {
    final newPartner = Map<String, String>.from(state.partner1);
    newPartner[key] = value;
    state = state.copyWith(partner1: newPartner);
  }

  void updatePartner2(String key, String value) {
    final newPartner = Map<String, String>.from(state.partner2);
    newPartner[key] = value;
    state = state.copyWith(partner2: newPartner);
  }

  void updatePartner1Languages(List<String> langs) {
    state = state.copyWith(partner1Languages: langs);
  }

  void updatePartner2Languages(List<String> langs) {
    state = state.copyWith(partner2Languages: langs);
  }
}

// --- PROVIDER ---
final profileEditProvider =
NotifierProvider<ProfileEditNotifier, ProfileEditState>(
  ProfileEditNotifier.new,
);

// --- WIDGET ---
class MyProfileEditTab extends ConsumerWidget {
  const MyProfileEditTab({super.key});

  static const List<String> _languageOptions = [
    'English',
    'Hindi',
    'German',
    'French',
    'Spanish',
  ];

  void _saveInterests() {
    Get.snackbar(
      'Success',
      'Interests saved successfully',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      borderRadius: 10,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileEditProvider);
    final notifier = ref.read(profileEditProvider.notifier);

    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final int columns = width >= 900 ? 3 : (width >= 560 ? 2 : 1);
        final double optionWidth = (width - (columns - 1) * 10 - 20) / columns;
        return Container(
          width: double.infinity,
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height * 0.62,
          ),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE8E0F2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionHeader(state, notifier),
              const SizedBox(height: 16),
              if (state.isProfileDetailsTab)
                _buildProfileDetailsContent(context, width, state, notifier)
              else
                _buildInterestsContent(optionWidth, state, notifier),
              const SizedBox(height: 18),
              Center(
                child: SizedBox(
                  width: 170,
                  child: ElevatedButton(
                    onPressed: _saveInterests,
                    style: ElevatedButton.styleFrom(
                      elevation: 4,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: const Color(0xFF220027),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                    child: const Text(
                      'Save Interest',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
            ],
          ),
        );
      },
    );
  }

  Widget _sectionHeader(ProfileEditState state, ProfileEditNotifier notifier) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF19001F), Color(0xFF490040)],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => notifier.toggleProfileTab(false),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: !state.isProfileDetailsTab ? const Color(0xFFFF2D87) : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'INTERESTS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const Spacer(),
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => notifier.toggleProfileTab(true),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: state.isProfileDetailsTab ? const Color(0xFFFF2D87) : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'PROFILE DETAILS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          // const SizedBox(width: 1),
        ],
      ),
    );
  }

  Widget _buildInterestsContent(double optionWidth, ProfileEditState state, ProfileEditNotifier notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'davidbrown',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 34, height: 1.05),
        ),
        const SizedBox(height: 8),
        Text(
          'What are you looking for? *Select all that apply',
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        _interestGroup(
          title: 'Swingers',
          expanded: state.isSwingersExpanded,
          onToggle: notifier.toggleSwingersExpanded,
          options: state.swingersOptions,
          optionWidth: optionWidth,
          onChanged: (label, value) => notifier.updateSwingersOption(label, value),
        ),
        const SizedBox(height: 12),
        _interestGroup(
          title: 'Hokup / Meetup',
          expanded: state.isHookupExpanded,
          onToggle: notifier.toggleHookupExpanded,
          options: state.hookupOptions,
          optionWidth: optionWidth,
          onChanged: (label, value) => notifier.updateHookupOption(label, value),
        ),
      ],
    );
  }

  Widget _buildProfileDetailsContent(BuildContext context, double width, ProfileEditState state, ProfileEditNotifier notifier) {
    final bool stacked = width < 760;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _textFieldLabel('INTRODUCE YOURSELF *'),
        const SizedBox(height: 6),
        _simpleTextField(
          initialValue: state.aboutMe,
          onChanged: notifier.updateAboutMe,
        ),
        const SizedBox(height: 10),
        _textFieldLabel('LOOKING FOR'),
        const SizedBox(height: 6),
        _simpleTextField(
          initialValue: state.lookingFor,
          maxLines: 2,
          onChanged: notifier.updateLookingFor,
        ),
        const SizedBox(height: 14),
        const Center(
          child: Text(
            'About Yourselves',
            style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(height: 12),
        if (stacked)
          Column(
            children: [
              _partnerPanel(
                context: context,
                title: 'Partner 1',
                data: state.partner1,
                languages: state.partner1Languages,
                onFieldChanged: notifier.updatePartner1,
                onLanguagesChanged: notifier.updatePartner1Languages,
              ),
              const SizedBox(height: 12),
              _partnerPanel(
                context: context,
                title: 'Partner 2',
                data: state.partner2,
                languages: state.partner2Languages,
                onFieldChanged: notifier.updatePartner2,
                onLanguagesChanged: notifier.updatePartner2Languages,
              ),
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _partnerPanel(
                  context: context,
                  title: 'Partner 1',
                  data: state.partner1,
                  languages: state.partner1Languages,
                  onFieldChanged: notifier.updatePartner1,
                  onLanguagesChanged: notifier.updatePartner1Languages,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _partnerPanel(
                  context: context,
                  title: 'Partner 2',
                  data: state.partner2,
                  languages: state.partner2Languages,
                  onFieldChanged: notifier.updatePartner2,
                  onLanguagesChanged: notifier.updatePartner2Languages,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _partnerPanel({
    required BuildContext context,
    required String title,
    required Map<String, String> data,
    required List<String> languages,
    required void Function(String, String) onFieldChanged,
    required void Function(List<String>) onLanguagesChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF19001F), Color(0xFF490040)]),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            title,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(height: 10),
        _dropdownField('DATE OF BIRTH', data, 'dateOfBirth', const ['17/06/2004', '03/12/2007'], onFieldChanged),
        // _dropdownField('HEIGHT', data, 'height', const ['4.6', '5.0', '5.7', '6.0'], onFieldChanged),

        // After (apostrophes — match "4'6" and "5'7")
        _dropdownField('HEIGHT', data, 'height', const ["4'6", "5'0", "5'7", "6'0"], onFieldChanged),
        _dropdownField('WEIGHT', data, 'weight', const ['55', '60', '65', '70'], onFieldChanged),
        _dropdownField('BODY TYPE', data, 'bodyType', const ['BBW', 'Athletic', 'Slim', 'Average'], onFieldChanged),
        _dropdownField('ETHNIC BACKGROUND', data, 'ethnic', const ['Italian', 'German', 'Indian'], onFieldChanged),
        _dropdownField('SEXUALITY', data, 'sexuality', const ['Straight', 'Bisexual', 'Gay'], onFieldChanged),
        _dropdownField('RELATIONSHIP ORIENTATION', data, 'orientation', const ["I'm not comfortable sharing that.", 'Swinger'], onFieldChanged),
        _dropdownField('TATTOOS', data, 'tattoos', const ['No', 'One', 'Many'], onFieldChanged),
        _dropdownField('PIERCINGS', data, 'piercings', const ['No', 'Yes'], onFieldChanged),
        _dropdownField('SMOKING', data, 'smoking', const ['No', 'Yes'], onFieldChanged),
        _dropdownField('DRINKING', data, 'drinking', const ['No', 'Yes', 'Occasionally'], onFieldChanged),
        _dropdownField('BODY HAIR', data, 'bodyHair', const ['Bikini', 'Arm, Chest', 'Trimmed', 'Natural'], onFieldChanged),
        _languagesField(context, 'LANGUAGES SPOKEN', languages, onLanguagesChanged),
        _dropdownField('LOOKS IMPORTANCE', data, 'looks', const ["I'm not comfortable sharing that.", 'Low', 'Medium', 'High'], onFieldChanged),
        _dropdownField('INTELLIGENCE IMPORTANCE', data, 'intelligence', const ['Low Importance', 'Medium Importance', 'Very Important'], onFieldChanged),
        _dropdownField('CIRCUMCISED', data, 'circumcised', const ['Yes', 'No', "I'm not comfortable sharing that."], onFieldChanged),
      ],
    );
  }

  Widget _dropdownField(
      String label,
      Map<String, String> data,
      String key,
      List<String> options,
      void Function(String, String) onFieldChanged,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _textFieldLabel(label),
          const SizedBox(height: 4),
          DropdownButtonFormField<String>(
            value: data[key],
            isExpanded: true,
            iconSize: 18,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
              overflow: TextOverflow.ellipsis,
            ),
            items: options
                .map(
                  (e) => DropdownMenuItem<String>(
                value: e,
                child: Text(
                  e,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
                .toList(),
            selectedItemBuilder: (context) {
              return options
                  .map(
                    (e) => Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    e,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
                  .toList();
            },
            onChanged: (value) {
              if (value == null) return;
              onFieldChanged(key, value);
            },
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFE8E0F2)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFE8E0F2)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _simpleTextField({
    required String initialValue,
    required void Function(String) onChanged,
    int maxLines = 1,
  }) {
    return TextFormField(
      initialValue: initialValue,
      maxLines: maxLines,
      onChanged: onChanged,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE8E0F2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE8E0F2)),
        ),
      ),
    );
  }

  Widget _textFieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.2,
      ),
    );
  }

  Widget _languagesField(BuildContext context, String label, List<String> selectedValues, void Function(List<String>) onSaved) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _textFieldLabel(label),
          const SizedBox(height: 4),
          InkWell(
            onTap: () => _openLanguageSelector(context, selectedValues, onSaved),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE8E0F2)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: selectedValues.isEmpty
                          ? [
                        Text(
                          'Select languages',
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                      ]
                          : selectedValues
                          .map(
                            (lang) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F4FF),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFD4DDF2)),
                          ),
                          child: Text(
                            lang,
                            style: const TextStyle(fontSize: 11),
                          ),
                        ),
                      )
                          .toList(),
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openLanguageSelector(BuildContext context, List<String> selectedValues, void Function(List<String>) onSaved) async {
    final temp = [...selectedValues];
    await showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Select Languages',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    ..._languageOptions.map(
                          (lang) => CheckboxListTile(
                        dense: true,
                        value: temp.contains(lang),
                        onChanged: (checked) {
                          setModalState(() {
                            if (checked == true) {
                              if (!temp.contains(lang)) temp.add(lang);
                            } else {
                              temp.remove(lang);
                            }
                          });
                        },
                        title: Text(lang),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          onSaved(temp);
                          Navigator.pop(context);
                        },
                        child: const Text('Done'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _interestGroup({
    required String title,
    required bool expanded,
    required VoidCallback onToggle,
    required Map<String, bool> options,
    required double optionWidth,
    required void Function(String label, bool value) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFECE4F4)),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF19001F), Color(0xFF490040)],
                ),
                borderRadius: BorderRadius.vertical(
                  top: const Radius.circular(10),
                  bottom: expanded ? Radius.zero : const Radius.circular(10),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        height: 1.0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: const Color(0xFFEACD71),
                    child: Icon(
                      expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      size: 16,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (expanded)
            Padding(
              padding: const EdgeInsets.all(10),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: options.entries
                    .map(
                      (entry) => _OptionChip(
                    label: entry.key,
                    selected: entry.value,
                    width: optionWidth,
                    onTap: () => onChanged(entry.key, !entry.value),
                  ),
                )
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}

class _OptionChip extends StatelessWidget {
  const _OptionChip({
    required this.label,
    required this.selected,
    required this.width,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final double width;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: width,
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFF1EBF8)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Checkbox(
              value: selected,
              onChanged: (_) => onTap(),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              activeColor: const Color(0xFF47003D),
              side: const BorderSide(color: Color(0xFFE0D4EE)),
            ),
          ],
        ),
      ),
    );
  }
}