import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:beatflirt/Api_services/api_service.dart';
import 'package:beatflirt/core/services/auth_services.dart';
import 'package:beatflirt/single_user_profile_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();
  
  List<SearchUserModel> _suggestions = [];
  List<SearchUserModel> _searchResults = [];
  bool _isSearching = false;
  bool _isLoadingSuggestions = false;
  String? _error;
  Timer? _debounce;
  bool _showSuggestions = false;
  bool _hasSearched = false;

  // Filter dialog values
  FilterSortType _sortType = FilterSortType.latest;
  final Set<ProfileFilterType> _profileFilters = {};
  final TextEditingController _filterUsernameController = TextEditingController();
  final TextEditingController _filterLocationController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _filterUsernameController.dispose();
    _filterLocationController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      setState(() {
        _suggestions = [];
        _showSuggestions = false;
      });
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      _fetchSuggestions(trimmed);
    });
  }

  Future<void> _fetchSuggestions(String query) async {
    if (!mounted) return;
    setState(() {
      _isLoadingSuggestions = true;
    });

    try {
      final token = await AuthService.getToken();
      final data = await _apiService.searchMembers(token: token, keyword: query);
      
      if (!mounted) return;
      setState(() {
        _suggestions = data.map((e) => SearchUserModel.fromJson(e)).toList();
        _showSuggestions = _suggestions.isNotEmpty;
        _isLoadingSuggestions = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoadingSuggestions = false;
      });
    }
  }

  Future<void> _executeSearch(String query) async {
    if (query.trim().isEmpty) return;
    
    FocusScope.of(context).unfocus();
    setState(() {
      _isSearching = true;
      _showSuggestions = false;
      _suggestions = [];
      _error = null;
      _hasSearched = true;
    });

    try {
      final token = await AuthService.getToken();
      final data = await _apiService.searchMembers(token: token, keyword: query);
      
      if (!mounted) return;
      setState(() {
        _searchResults = data.map((e) => SearchUserModel.fromJson(e)).toList();
        _isSearching = false;
      });
    } catch (e) {
      if (!mounted) return;
      final errStr = e.toString().replaceFirst('Exception: ', '');
      setState(() {
        if (errStr.toLowerCase().contains('no record') || errStr.toLowerCase().contains('not found')) {
          _searchResults = [];
          _error = null;
        } else {
          _error = errStr;
        }
        _isSearching = false;
      });
    }
  }

  Future<void> _openFilterDialog() async {
    final result = await showDialog<_FilterResult>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (context) => _FilterDialog(
        initialSortType: _sortType,
        initialProfileFilters: _profileFilters,
        initialUsername: _filterUsernameController.text,
        initialLocation: _filterLocationController.text,
      ),
    );

    if (result == null) return;

    setState(() {
      _sortType = result.sortType;
      _profileFilters.clear();
      _profileFilters.addAll(result.profileFilters);
      _filterUsernameController.text = result.username;
      _filterLocationController.text = result.location;
    });

    // Execute filtered search if query is present, otherwise search by filters
    final searchKey = _filterUsernameController.text.isNotEmpty 
        ? _filterUsernameController.text 
        : _searchController.text;
    
    if (searchKey.isNotEmpty) {
      _searchController.text = searchKey;
      _executeSearch(searchKey);
    }
  }

  List<SearchUserModel> get _filteredResults {
    return _searchResults.where((user) {
      // 1. Sort type or basic matches
      if (_profileFilters.isNotEmpty) {
        final profileType = user.profileType.toLowerCase();
        bool matchesFilter = false;
        if (_profileFilters.contains(ProfileFilterType.couples) && profileType.contains('couple')) {
          matchesFilter = true;
        }
        if (_profileFilters.contains(ProfileFilterType.females) && (profileType.contains('female') || user.genderProfileType.toLowerCase().contains('female'))) {
          matchesFilter = true;
        }
        if (_profileFilters.contains(ProfileFilterType.males) && (profileType.contains('male') || user.genderProfileType.toLowerCase().contains('male'))) {
          matchesFilter = true;
        }
        if (_profileFilters.contains(ProfileFilterType.transgenders) && profileType.contains('trans')) {
          matchesFilter = true;
        }
        if (!matchesFilter) return false;
      }

      // 2. Location keyword filter
      if (_filterLocationController.text.trim().isNotEmpty) {
        final loc = _filterLocationController.text.trim().toLowerCase();
        if (!user.formattedAddress.toLowerCase().contains(loc) &&
            !user.cityName.toLowerCase().contains(loc)) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final results = _filteredResults;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF4FA), // Soft light pink body background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Search Members',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // ── Top Search Input Bar ──
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              textInputAction: TextInputAction.search,
                              onSubmitted: (val) => _executeSearch(val),
                              onChanged: _onSearchChanged,
                              style: const TextStyle(color: Colors.black, fontSize: 16),
                              decoration: const InputDecoration(
                                hintText: "Search Here...",
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _executeSearch(_searchController.text),
                            child: SvgPicturePlaceholder(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // ── Search Results Grid ──
                Expanded(
                  child: _isSearching
                      ? const Center(child: CircularProgressIndicator(color: Color(0xFF560827)))
                      : _error != null
                          ? Center(child: Text(_error!, style: const TextStyle(color: Colors.black54)))
                          : !_hasSearched
                              ? const Center(
                                  child: Text(
                                    'Search for members above.',
                                    style: TextStyle(color: Colors.black54, fontSize: 16),
                                  ),
                                )
                              : Column(
                                  children: [
                                    // Results Header with Filters Icon
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              'Search Results (${_searchController.text})',
                                              style: const TextStyle(
                                                color: Color(0xFF1D042A),
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.tune, color: Color(0xFF560827), size: 28),
                                            onPressed: _openFilterDialog,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: results.isEmpty
                                          ? _buildNoRecordFoundCard()
                                          : GridView.builder(
                                              padding: const EdgeInsets.all(20),
                                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 1,
                                                mainAxisSpacing: 24,
                                                mainAxisExtent: 470,
                                              ),
                                              itemCount: results.length,
                                              itemBuilder: (context, index) {
                                                return _buildUserCard(results[index]);
                                              },
                                            ),
                                    ),
                                  ],
                                ),
                ),
              ],
            ),

            // ── Suggestions overlay ──
            if (_showSuggestions && _suggestions.isNotEmpty)
              Positioned(
                top: 80,
                left: 20,
                right: 20,
                child: Material(
                  elevation: 6,
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 250),
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: _suggestions.length,
                      separatorBuilder: (context, index) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final item = _suggestions[index];
                        return ListTile(
                          leading: CircleAvatar(
                            radius: 20,
                            backgroundImage: item.primaryImage.isNotEmpty
                                ? NetworkImage(item.primaryImage)
                                : null,
                            child: item.primaryImage.isEmpty
                                ? const Icon(Icons.person, color: Colors.grey)
                                : null,
                          ),
                          title: Text(
                            item.username,
                            style: const TextStyle(
                              color: Color(0xFF560827),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          onTap: () {
                            _searchController.text = item.username;
                            _executeSearch(item.username);
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard(SearchUserModel user) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        GestureDetector(
          onTap: () => _navigateToProfile(user.id),
          child: Container(
            margin: const EdgeInsets.only(top: 60),
            height: 380,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF560827), Color(0xFF06032C)],
              ),
              boxShadow: const [
                BoxShadow(color: Color(0x4D000000), blurRadius: 30, offset: Offset(0, 15)),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 64, 16, 12),
              child: Column(
                children: [
                  Text(
                    user.username,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  // Age Pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE91E63),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      user.age2 > 0 ? 'Age ${user.age} | ${user.age2}' : 'Age ${user.age}',
                      style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Gender Icons Row
                  _buildGenderIcons(user),
                  const SizedBox(height: 10),
                  Text(
                    user.genderProfileType,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  // Location Pin Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.location_on, color: Colors.white70, size: 18),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          '${user.formattedAddress} | ${user.totalDistance} ${user.distance}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Chat heart bubble
                  GestureDetector(
                    onTap: () => _navigateToProfile(user.id),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Colors.white24,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(Icons.chat_bubble, color: Colors.pinkAccent, size: 26),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Overlapping top avatar
        Positioned(
          top: 0,
          child: GestureDetector(
            onTap: () => _navigateToProfile(user.id),
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE91E63), width: 4),
                color: Colors.white,
              ),
              clipBehavior: Clip.antiAlias,
              child: user.primaryImage.isNotEmpty
                  ? Image.network(
                      user.primaryImage,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.person, color: Color(0xFF560827), size: 46),
                    )
                  : const Icon(Icons.person, color: Color(0xFF560827), size: 46),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderIcons(SearchUserModel user) {
    final List<Widget> icons = [];
    final double size = 20;

    if (user.coupleMaleFemaleSwingers) {
      icons.add(const Icon(Icons.male, color: Colors.blue, size: 20));
      icons.add(const Icon(Icons.female, color: Colors.pink, size: 20));
    }
    if (user.coupleFemaleFemaleSwingers) {
      icons.add(const Icon(Icons.female, color: Colors.pink, size: 20));
      icons.add(const Icon(Icons.female, color: Colors.pink, size: 20));
    }
    if (user.coupleMaleMaleSwingers) {
      icons.add(const Icon(Icons.male, color: Colors.blue, size: 20));
      icons.add(const Icon(Icons.male, color: Colors.blue, size: 20));
    }

    if (icons.isEmpty) {
      // Default fallback
      if (user.genderProfileType.toLowerCase().contains('female')) {
        icons.add(const Icon(Icons.female, color: Colors.pink, size: 20));
      } else {
        icons.add(const Icon(Icons.male, color: Colors.blue, size: 20));
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: icons.map((e) => Padding(padding: const EdgeInsets.symmetric(horizontal: 2), child: e)).toList(),
    );
  }

  void _navigateToProfile(String userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BeatSingleUserProfileScreen(userId: userId),
      ),
    );
  }

  Widget _buildNoRecordFoundCard() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  color: Color(0xFFEAEFFB),
                  shape: BoxShape.circle,
                ),
                child: const Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.person,
                      size: 56,
                      color: Color(0xFF560827),
                    ),
                    Positioned(
                      right: 32,
                      bottom: 32,
                      child: Icon(
                        Icons.close,
                        size: 26,
                        color: Color(0xFF560827),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'No Record Found!',
                style: TextStyle(
                  color: Color(0xFF1D042A),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                "It looks like we couldn't find any members matching your search criteria. Why not try with different keywords?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Search Suggestion magnifying glass ──
class SvgPicturePlaceholder extends StatelessWidget {
  const SvgPicturePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.search, color: Colors.pinkAccent, size: 18),
    );
  }
}

// ── Filter Dialog Widget ──
class _FilterDialog extends StatefulWidget {
  const _FilterDialog({
    required this.initialSortType,
    required this.initialProfileFilters,
    required this.initialUsername,
    required this.initialLocation,
  });

  final FilterSortType initialSortType;
  final Set<ProfileFilterType> initialProfileFilters;
  final String initialUsername;
  final String initialLocation;

  @override
  State<_FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<_FilterDialog> {
  late FilterSortType _sortType;
  late Set<ProfileFilterType> _profileFilters;
  late TextEditingController _usernameController;
  late TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    _sortType = widget.initialSortType;
    _profileFilters = {...widget.initialProfileFilters};
    _usernameController = TextEditingController(text: widget.initialUsername);
    _locationController = TextEditingController(text: widget.initialLocation);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF4A0E2E), // Dark burgundy background
          borderRadius: BorderRadius.circular(16),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Radios: Latest / All
              _buildRadio('Latest', FilterSortType.latest),
              _buildRadio('All', FilterSortType.all),
              const Divider(color: Colors.white24, height: 20),

              // Checkboxes: Couples, Females, Males, Transgenders
              _buildCheckbox('Couples', ProfileFilterType.couples, Colors.purpleAccent),
              _buildCheckbox('Females', ProfileFilterType.females, Colors.pinkAccent),
              _buildCheckbox('Males', ProfileFilterType.males, Colors.blueAccent),
              _buildCheckbox('Transgenders', ProfileFilterType.transgenders, Colors.tealAccent),

              const SizedBox(height: 16),
              // Search Input Fields
              _buildInputField('Search Username...', _usernameController),
              const SizedBox(height: 12),
              _buildInputField('Search Location...', _locationController),

              const SizedBox(height: 20),
              // Ok Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(
                      context,
                      _FilterResult(
                        sortType: _sortType,
                        profileFilters: _profileFilters,
                        username: _usernameController.text,
                        location: _locationController.text,
                      ),
                    );
                  },
                  child: const Text('Ok', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRadio(String label, FilterSortType value) {
    return InkWell(
      onTap: () => setState(() => _sortType = value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(
              _sortType == value ? Icons.radio_button_checked : Icons.radio_button_off,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckbox(String label, ProfileFilterType type, Color dotColor) {
    final isChecked = _profileFilters.contains(type);
    return InkWell(
      onTap: () {
        setState(() {
          if (isChecked) {
            _profileFilters.remove(type);
          } else {
            _profileFilters.add(type);
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(
              isChecked ? Icons.check_box : Icons.check_box_outline_blank,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 16)),
            const SizedBox(width: 8),
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String hint, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

// ── Models & Enums ──
enum FilterSortType { latest, all }
enum ProfileFilterType { couples, females, males, transgenders }

class _FilterResult {
  final FilterSortType sortType;
  final Set<ProfileFilterType> profileFilters;
  final String username;
  final String location;

  _FilterResult({
    required this.sortType,
    required this.profileFilters,
    required this.username,
    required this.location,
  });
}

class SearchUserModel {
  final String id;
  final String username;
  final String profileType;
  final String genderProfileType;
  final String cityName;
  final String formattedAddress;
  final int totalDistance;
  final String distance;
  final int age;
  final int age2;
  final String primaryImage;
  
  final bool coupleMaleFemaleSwingers;
  final bool coupleFemaleFemaleSwingers;
  final bool coupleMaleMaleSwingers;

  SearchUserModel({
    required this.id,
    required this.username,
    required this.profileType,
    required this.genderProfileType,
    required this.cityName,
    required this.formattedAddress,
    required this.totalDistance,
    required this.distance,
    required this.age,
    required this.age2,
    required this.primaryImage,
    required this.coupleMaleFemaleSwingers,
    required this.coupleFemaleFemaleSwingers,
    required this.coupleMaleMaleSwingers,
  });

  factory SearchUserModel.fromJson(Map<String, dynamic> json) {
    final imageList = json['image'] as List<dynamic>? ?? [];
    String mainImage = '';
    if (imageList.isNotEmpty) {
      mainImage = imageList.first['profile_image']?.toString() ?? '';
    }

    return SearchUserModel(
      id: json['id']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      profileType: json['profile_type']?.toString() ?? '',
      genderProfileType: json['gender_profile_type']?.toString() ?? '',
      cityName: json['city_name']?.toString() ?? '',
      formattedAddress: json['formatted_address']?.toString() ?? '',
      totalDistance: int.tryParse(json['total_distance']?.toString() ?? '') ?? 0,
      distance: json['distance']?.toString() ?? 'km',
      age: int.tryParse(json['age']?.toString() ?? '') ?? 18,
      age2: int.tryParse(json['age2']?.toString() ?? '') ?? 0,
      primaryImage: mainImage,
      coupleMaleFemaleSwingers: json['couple_male_female_swingers']?.toString() == '1',
      coupleFemaleFemaleSwingers: json['couple_female_female_swingers']?.toString() == '1',
      coupleMaleMaleSwingers: json['couple_male_male_swingers']?.toString() == '1',
    );
  }
}
