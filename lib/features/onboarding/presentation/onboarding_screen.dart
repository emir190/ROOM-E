import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/turkey_locations.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/turkish_char_bar.dart';
import '../application/onboarding_controller.dart';
import '../domain/entities/onboarding_data.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  // Step 1 Controllers
  late final TextEditingController _nameController;
  late final TextEditingController _bioController;
  late int _birthYear;
  late Gender _gender;
  Uint8List? _selectedPhotoBytes;

  static const List<String> _presetAvatars = [
    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80',
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=400&q=80',
    'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=400&q=80',
    'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=400&q=80',
  ];

  // Step 2 Controllers
  late HousingIntent _intent;
  late final TextEditingController _cityController;
  late final TextEditingController _districtController;
  late final TextEditingController _totalRentController;
  late RangeValues _budgetRange;
  late double _totalHouseRent;
  late int _householdPersonCount;
  late DateTime _moveInDate;
  late int _leaseMonths;

  // Step 3 Controllers
  late List<Gender> _genderPreference;
  late bool _smokingDealbreaker;
  late bool _petsDealbreaker;
  late double _maxAgeGap;

  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final data = ref.read(onboardingControllerProvider).data;

    _nameController = TextEditingController(text: data.displayName);
    _bioController = TextEditingController(text: data.bio);
    _birthYear = data.birthYear;
    _gender = data.gender;

    _intent = data.intent;
    _cityController = TextEditingController(text: data.city);
    _districtController = TextEditingController(text: data.district);
    _budgetRange = RangeValues(data.budgetMin, data.budgetMax);
    _totalHouseRent = data.totalHouseRent;
    _householdPersonCount = data.householdPersonCount;
    _totalRentController = TextEditingController(text: data.totalHouseRent.round().toString());
    _moveInDate = data.moveInDate;
    _leaseMonths = data.leaseMonths;

    _genderPreference = List<Gender>.from(data.filters.genderPreference);
    _smokingDealbreaker = data.filters.smokingDealbreaker;
    _petsDealbreaker = data.filters.petsDealbreaker;
    _maxAgeGap = data.filters.maxAgeGap.toDouble();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _totalRentController.dispose();
    super.dispose();
  }

  Future<void> _pickImageFromSource(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );
      if (picked != null) {
        final bytes = await picked.readAsBytes();
        if (mounted) {
          setState(() {
            _selectedPhotoBytes = bytes;
          });
        }
        await ref.read(onboardingControllerProvider.notifier).uploadPhoto(File(picked.path));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profil fotoğrafınız başarıyla eklendi!'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cihaz galerisi açılamadı. Hazır profil fotoğraflarından birini seçebilirsiniz.'),
          ),
        );
      }
    }
  }

  void _showPhotoPickerOptions() {
    final theme = Theme.of(context);
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Profil Fotoğrafı Seç',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: Icon(Icons.photo_library_rounded, color: theme.colorScheme.primary),
                  title: const Text('Galeriden Fotoğraf Seç', style: TextStyle(fontWeight: FontWeight.w600)),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickImageFromSource(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_camera_rounded, color: theme.colorScheme.primary),
                  title: const Text('Kamerayla Fotoğraf Çek', style: TextStyle(fontWeight: FontWeight.w600)),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickImageFromSource(ImageSource.camera);
                  },
                ),
                const Divider(height: 20),
                const Text(
                  'Veya Hazır Avatar Seçin:',
                  style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _presetAvatars.map((avatarUrl) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedPhotoBytes = null;
                        });
                        ref.read(onboardingControllerProvider.notifier).setPhotoUrl(avatarUrl);
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Profil fotoğrafınız güncellendi!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        radius: 28,
                        backgroundImage: NetworkImage(avatarUrl),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  ImageProvider? _resolveAvatarImage(List<String> photoUrls) {
    if (_selectedPhotoBytes != null) {
      return MemoryImage(_selectedPhotoBytes!);
    }
    if (photoUrls.isEmpty) return null;
    final first = photoUrls.first;
    if (first.startsWith('http://') || first.startsWith('https://')) {
      return NetworkImage(first);
    }
    final file = File(first);
    if (file.existsSync()) {
      return FileImage(file);
    }
    return null;
  }

  void _onNext() {
    final controller = ref.read(onboardingControllerProvider.notifier);
    final currentStep = ref.read(onboardingControllerProvider).currentStep;

    if (currentStep == 0) {
      if (_nameController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lütfen adınızı girin / Please enter your name')),
        );
        return;
      }
      controller.updateBasicProfile(
        displayName: _nameController.text.trim(),
        birthYear: _birthYear,
        gender: _gender,
        bio: _bioController.text.trim(),
      );
      controller.nextStep();
    } else if (currentStep == 1) {
      controller.updateHousingIntent(
        intent: _intent,
        city: _cityController.text.trim(),
        district: _districtController.text.trim(),
        budgetMin: _budgetRange.start,
        budgetMax: _budgetRange.end,
        totalHouseRent: _totalHouseRent,
        householdPersonCount: _householdPersonCount,
        moveInDate: _moveInDate,
        leaseMonths: _leaseMonths,
      );
      controller.nextStep();
    } else if (currentStep == 2) {
      controller.updateHardFilters(
        genderPreference: _genderPreference,
        smokingDealbreaker: _smokingDealbreaker,
        petsDealbreaker: _petsDealbreaker,
        maxAgeGap: _maxAgeGap.toInt(),
      );
      controller.completeOnboarding().then((success) {
        if (success && mounted) {
          context.go('/scenarios');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final state = ref.watch(onboardingControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Step ${state.currentStep + 1} / 3',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        leading: state.currentStep > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => ref.read(onboardingControllerProvider.notifier).previousStep(),
              )
            : null,
      ),
      body: SafeArea(
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (state.currentStep + 1) / 3,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimensions.lg),
                child: switch (state.currentStep) {
                  0 => _buildStep1(l10n, theme, state),
                  1 => _buildStep2(l10n, theme),
                  _ => _buildStep3(l10n, theme),
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppDimensions.lg),
              child: AppButton(
                text: state.currentStep == 2 ? l10n.completeOnboardingButton : l10n.continueButton,
                isLoading: state.isLoading,
                onPressed: _onNext,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep1(AppLocalizations l10n, ThemeData theme, OnboardingState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.onboardingStep1Title,
          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppDimensions.xs),
        Text(
          l10n.onboardingStep1Subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: AppDimensions.xl),
        Center(
          child: GestureDetector(
            onTap: _showPhotoPickerOptions,
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 54,
                      backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                      backgroundImage: _resolveAvatarImage(state.data.photoUrls),
                      child: _resolveAvatarImage(state.data.photoUrls) == null
                          ? Icon(Icons.person_rounded, size: 54, color: theme.colorScheme.primary)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: theme.colorScheme.primary,
                        child: state.isUploadingPhoto
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                                onPressed: _showPhotoPickerOptions,
                              ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _resolveAvatarImage(state.data.photoUrls) == null
                      ? l10n.uploadPhoto
                      : 'Fotoğrafı Değiştir',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.lg),
        AppTextField(
          controller: _nameController,
          label: l10n.displayNameLabel,
          hint: 'Adınız Soyadınız',
        ),
        const SizedBox(height: AppDimensions.md),
        Text(
          l10n.birthYearLabel,
          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<int>(
          initialValue: _birthYear,
          items: List.generate(
            45,
            (index) {
              final year = DateTime.now().year - 18 - index;
              return DropdownMenuItem(value: year, child: Text('$year (${DateTime.now().year - year} yaş)'));
            },
          ),
          onChanged: (val) {
            if (val != null) setState(() => _birthYear = val);
          },
        ),
        const SizedBox(height: AppDimensions.md),
        Text(
          l10n.genderLabel,
          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: Gender.values.map((g) {
            final isSelected = _gender == g;
            final label = switch (g) {
              Gender.female => l10n.genderFemale,
              Gender.male => l10n.genderMale,
              Gender.nonBinary => l10n.genderNonBinary,
              Gender.preferNotToSay => l10n.genderPreferNotToSay,
            };
            return ChoiceChip(
              label: Text(label),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) setState(() => _gender = g);
              },
            );
          }).toList(),
        ),
        const SizedBox(height: AppDimensions.md),
        AppTextField(
          controller: _bioController,
          label: l10n.bioLabel,
          hint: 'Müzik dinlemeyi ve sessiz bir ortamda çalışmayı severim...',
          maxLines: 3,
        ),
      ],
    );
  }

  void _showAlphabeticalLocationPicker({
    required String title,
    required List<String> items,
    required String currentValue,
    required ValueChanged<String> onSelected,
  }) {
    String searchQuery = '';
    final searchController = TextEditingController();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (modalCtx, setModalState) {
            final normalizedQuery = TurkishTextUtils.normalizeForSearch(searchQuery);
            final lowerQuery = TurkishTextUtils.toLowerTurkish(searchQuery);
            final filtered = items.where((item) {
              if (searchQuery.trim().isEmpty) return true;
              return TurkishTextUtils.toLowerTurkish(item).contains(lowerQuery) ||
                  TurkishTextUtils.normalizeForSearch(item).contains(normalizedQuery);
            }).toList();
            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.72,
              maxChildSize: 0.92,
              minChildSize: 0.45,
              builder: (_, scrollController) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            title,
                            style: Theme.of(modalCtx)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(modalCtx),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Alfabetik listede ara...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                        onChanged: (val) {
                          setModalState(() => searchQuery = val);
                        },
                      ),
                      TurkishCharBar(
                        controller: searchController,
                        onChanged: (val) {
                          setModalState(() => searchQuery = val);
                        },
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.separated(
                          controller: scrollController,
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (_, idx) {
                            final val = filtered[idx];
                            final isSelected = val == currentValue;
                            return ListTile(
                              title: Text(
                                val,
                                style: TextStyle(
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  color: isSelected ? AppColors.primaryTeal : null,
                                ),
                              ),
                              trailing: isSelected
                                  ? const Icon(Icons.check_circle, color: AppColors.primaryTeal)
                                  : null,
                              onTap: () {
                                Navigator.pop(modalCtx);
                                onSelected(val);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildStep2(AppLocalizations l10n, ThemeData theme) {
    final cities = TurkeyLocations.sortedCities;
    final districts = TurkeyLocations.getDistrictsForCity(_cityController.text.trim());
    final perPersonRent =
        _householdPersonCount > 0 ? (_totalHouseRent / _householdPersonCount).round() : _totalHouseRent.round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.onboardingStep2Title,
          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppDimensions.xs),
        Text(
          l10n.onboardingStep2Subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: AppDimensions.xl),
        SegmentedButton<HousingIntent>(
          segments: [
            ButtonSegment(
              value: HousingIntent.needRoom,
              label: Text(l10n.intentLooking),
              icon: const Icon(Icons.search_rounded),
            ),
            ButtonSegment(
              value: HousingIntent.haveRoom,
              label: Text(l10n.intentHaveRoom),
              icon: const Icon(Icons.home_rounded),
            ),
          ],
          selected: {_intent},
          onSelectionChanged: (set) {
            setState(() => _intent = set.first);
          },
        ),
        const SizedBox(height: AppDimensions.lg),

        // Özellik 1: Alfabetik İl Seçimi
        GestureDetector(
          onTap: () {
            _showAlphabeticalLocationPicker(
              title: 'İl Seçin (A-Z Alfabetik)',
              items: cities,
              currentValue: _cityController.text.trim(),
              onSelected: (selectedCity) {
                final cityDistricts = TurkeyLocations.getDistrictsForCity(selectedCity);
                setState(() {
                  _cityController.text = selectedCity;
                  _districtController.text =
                      cityDistricts.isNotEmpty ? cityDistricts.first : '';
                });
              },
            );
          },
          child: AbsorbPointer(
            child: AppTextField(
              controller: _cityController,
              label: '${l10n.cityLabel} (A-Z Alfabetik Seçim)',
              hint: 'İl seçmek için dokunun',
              suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.md),

        // Özellik 1: Seçilen İle Göre Alfabetik İlçe Seçimi
        GestureDetector(
          onTap: () {
            if (districts.isEmpty) return;
            _showAlphabeticalLocationPicker(
              title: '${_cityController.text} İlçeleri (A-Z Alfabetik)',
              items: districts,
              currentValue: _districtController.text.trim(),
              onSelected: (selectedDistrict) {
                setState(() {
                  _districtController.text = selectedDistrict;
                });
              },
            );
          },
          child: AbsorbPointer(
            child: AppTextField(
              controller: _districtController,
              label: '${l10n.districtLabel} (${_cityController.text} İlçeleri A-Z)',
              hint: 'İlçe seçmek için dokunun',
              suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.lg),

        // Özellik 2: "Evim Var, Ev Arkadaşı Arıyorum" vs "Oda Arıyorum"
        if (_intent == HousingIntent.needRoom) ...[
          Text(
            'Bütçe Aralığı: ₺${_budgetRange.start.round()} - ₺${_budgetRange.end.round()}',
            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          RangeSlider(
            values: _budgetRange,
            min: 3000,
            max: 45000,
            divisions: 42,
            labels: RangeLabels(
              '₺${_budgetRange.start.round()}',
              '₺${_budgetRange.end.round()}',
            ),
            onChanged: (values) {
              setState(() => _budgetRange = values);
            },
          ),
        ] else ...[
          Card(
            elevation: 0,
            color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              side: BorderSide(color: AppColors.primaryTeal.withValues(alpha: 0.35)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Evin Toplam Kirası (Ödediğiniz Kira): ₺${_totalHouseRent.round()}',
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _totalRentController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Toplam Ev Kirası (₺)',
                      prefixText: '₺ ',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    onChanged: (val) {
                      final parsed = double.tryParse(val.trim());
                      if (parsed != null && parsed > 0) {
                        setState(() {
                          _totalHouseRent = parsed.clamp(3000, 120000);
                        });
                      }
                    },
                  ),
                  Slider(
                    value: _totalHouseRent.clamp(5000, 90000),
                    min: 5000,
                    max: 90000,
                    divisions: 85,
                    label: '₺${_totalHouseRent.round()}',
                    onChanged: (val) {
                      setState(() {
                        _totalHouseRent = val;
                        _totalRentController.text = val.round().toString();
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Evde Toplam Kaç Kişi Yaşayacak? ($_householdPersonCount Kişi)',
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [2, 3, 4, 5, 6].map((count) {
                      return ChoiceChip(
                        label: Text('$count Kişi'),
                        selected: _householdPersonCount == count,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() => _householdPersonCount = count);
                          }
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.primaryTeal.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primaryTeal.withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calculate_rounded, color: AppColors.primaryTeal, size: 28),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Kişi Başı Düşecek Aylık Kira',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                '₺$perPersonRent / kişi başı',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryTeal,
                                ),
                              ),
                              Text(
                                'Toplam ₺${_totalHouseRent.round()} kira ÷ $_householdPersonCount kişi',
                                style: const TextStyle(fontSize: 11.5, color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        const SizedBox(height: AppDimensions.md),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            l10n.moveInDateLabel,
            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          subtitle: Text('${_moveInDate.day}.${_moveInDate.month}.${_moveInDate.year}'),
          trailing: const Icon(Icons.calendar_month_rounded),
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: _moveInDate,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 180)),
            );
            if (picked != null) {
              setState(() => _moveInDate = picked);
            }
          },
        ),
        const SizedBox(height: AppDimensions.sm),
        Text(
          '${l10n.leaseMonthsLabel}: $_leaseMonths ay',
          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        Slider(
          value: _leaseMonths.toDouble(),
          min: 3,
          max: 24,
          divisions: 7,
          label: '$_leaseMonths ay',
          onChanged: (val) {
            setState(() => _leaseMonths = val.toInt());
          },
        ),
      ],
    );
  }

  Widget _buildStep3(AppLocalizations l10n, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.onboardingStep3Title,
          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppDimensions.xs),
        Text(
          l10n.onboardingStep3Subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: AppDimensions.xl),
        Text(
          l10n.genderPreferenceLabel,
          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [Gender.female, Gender.male, Gender.nonBinary].map((g) {
            final isSelected = _genderPreference.contains(g);
            final label = switch (g) {
              Gender.female => l10n.genderFemale,
              Gender.male => l10n.genderMale,
              Gender.nonBinary => l10n.genderNonBinary,
              _ => '',
            };
            return FilterChip(
              label: Text(label),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _genderPreference.add(g);
                  } else {
                    if (_genderPreference.length > 1) {
                      _genderPreference.remove(g);
                    }
                  }
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: AppDimensions.lg),
        SwitchListTile(
          title: Text(l10n.smokingForbidden),
          subtitle: const Text('Evde kesinlikle sigara içilmemeli'),
          value: _smokingDealbreaker,
          onChanged: (val) {
            setState(() => _smokingDealbreaker = val);
          },
        ),
        SwitchListTile(
          title: Text(l10n.petsForbidden),
          subtitle: const Text('Alerji veya tercih sebebiyle evcil hayvansız olmalı'),
          value: _petsDealbreaker,
          onChanged: (val) {
            setState(() => _petsDealbreaker = val);
          },
        ),
        const SizedBox(height: AppDimensions.md),
        Text(
          '${l10n.maxAgeGapLabel}: ±${_maxAgeGap.toInt()} yaş',
          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        Slider(
          value: _maxAgeGap,
          min: 3,
          max: 20,
          divisions: 17,
          label: '±${_maxAgeGap.toInt()} yaş',
          onChanged: (val) {
            setState(() => _maxAgeGap = val);
          },
        ),
      ],
    );
  }
}
