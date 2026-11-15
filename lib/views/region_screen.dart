import 'package:castlog/controllers/session_controller.dart';
import 'package:castlog/services/location_service.dart';
import 'package:castlog/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class RegionScreen extends StatefulWidget {
  const RegionScreen({super.key});

  @override
  State<RegionScreen> createState() => _RegionScreenState();
}

class _RegionScreenState extends State<RegionScreen> {
  final SessionController _sessionController = Get.find<SessionController>();

  final Map<String, List<String>> _provinceCities = {
    'DI Yogyakarta': [
      'Kota Yogyakarta',
      'Sleman',
      'Bantul',
      'Kulon Progo',
      'Gunungkidul',
    ],
    'DKI Jakarta': [
      'Jakarta Pusat',
      'Jakarta Selatan',
      'Jakarta Barat',
      'Jakarta Timur',
      'Jakarta Utara',
    ],
    'Jawa Barat': [
      'Bandung',
      'Bogor',
      'Bekasi',
      'Depok',
      'Cirebon',
    ],
    'Jawa Timur': [
      'Surabaya',
      'Malang',
      'Kediri',
      'Madiun',
      'Banyuwangi',
    ],
    'Bali': [
      'Denpasar',
      'Badung',
      'Gianyar',
      'Tabanan',
      'Buleleng',
    ],
  };

  String? _selectedProvince = 'DI Yogyakarta';
  String? _selectedCity = 'Kota Yogyakarta';
  String _regionScope = 'City / Regency';

  // LBS State
  bool _isDetectingGps = false;
  LocationResult? _detectedLocation;

  @override
  void initState() {
    super.initState();
    // Initialize based on existing sessionController region
    final current = _sessionController.userRegion.value;
    for (final p in _provinceCities.keys) {
      if (current.contains(p)) {
        _selectedProvince = p;
        break;
      }
    }
    _selectedCity = _provinceCities[_selectedProvince]?.first;
  }

  Future<void> _detectGpsLocation() async {
    setState(() => _isDetectingGps = true);
    try {
      final result = await LocationService().detectUserRegion();
      setState(() {
        _detectedLocation = result;
        _selectedProvince = result.province;
        if (_provinceCities.containsKey(result.province)) {
          final cities = _provinceCities[result.province]!;
          if (cities.contains(result.city)) {
            _selectedCity = result.city;
          } else {
            _selectedCity = cities.first;
          }
        }
      });

      _sessionController.setUserRegion(result.formattedRegion);

      Get.snackbar(
        'Location Detected',
        'Coordinates: ${result.displayCoordinates}\nRegion: ${result.formattedRegion}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.paper,
        colorText: AppColors.ink,
        borderRadius: 0,
        borderColor: AppColors.ink,
        borderWidth: 1,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      Get.snackbar(
        'Location Detection Failed',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.paper,
        colorText: Colors.red.shade800,
        borderRadius: 0,
        borderColor: Colors.red.shade800,
        borderWidth: 1,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      setState(() => _isDetectingGps = false);
    }
  }

  void _onProvinceChanged(String? newProvince) {
    setState(() {
      _selectedProvince = newProvince;
      if (newProvince != null && _provinceCities.containsKey(newProvince)) {
        _selectedCity = _provinceCities[newProvince]!.first;
      } else {
        _selectedCity = null;
      }
    });
  }

  void _saveRegion() {
    if (_selectedProvince == null) {
      Get.snackbar(
        'Required',
        'Please select a province',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.paper,
        colorText: AppColors.ink,
        borderRadius: 0,
        borderColor: AppColors.ink,
        borderWidth: 1,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    String finalRegion;
    if (_regionScope == 'Province' || _selectedCity == null) {
      finalRegion = _selectedProvince!;
    } else {
      finalRegion = '$_selectedCity, $_selectedProvince';
    }

    _sessionController.setUserRegion(finalRegion);

    Get.snackbar(
      'Region Updated',
      'Region set to $finalRegion',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.paper,
      colorText: AppColors.ink,
      borderRadius: 0,
      borderColor: AppColors.ink,
      borderWidth: 1,
      margin: const EdgeInsets.all(16),
    );

    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    final availableCities = _selectedProvince != null
        ? (_provinceCities[_selectedProvince] ?? [])
        : <String>[];

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
              GestureDetector(
                onTap: () => Get.back(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.arrow_back, size: 16, color: AppColors.muted),
                    const SizedBox(width: 6),
                    Text(
                      'Leaderboard',
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Eyebrow
              Text(
                'COMMUNITY PREFERENCES',
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: AppColors.muted,
                ),
              ),
              const SizedBox(height: 8),

              // Title
              Text(
                'Your region.',
                style: GoogleFonts.manrope(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1.2,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 8),

              // Subtitle
              Text(
                'Choose where you want to compete. Your local ranking will follow this selection.',
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  height: 1.5,
                  color: AppColors.muted,
                ),
              ),
              const SizedBox(height: 24),

              // LBS Location Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.paper,
                  border: Border.all(color: AppColors.line),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'LOCATION-BASED SERVICE (LBS)',
                          style: GoogleFonts.dmSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                            color: AppColors.muted,
                          ),
                        ),
                        if (_detectedLocation != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            color: AppColors.ink,
                            child: Text(
                              'GPS ACTIVE',
                              style: GoogleFonts.dmSans(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Automatically detect device GPS coordinates to place your profile into the local regional leaderboard.',
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        color: AppColors.muted,
                        height: 1.4,
                      ),
                    ),
                    if (_detectedLocation != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        color: AppColors.bg,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.gps_fixed, size: 14, color: AppColors.ink),
                                const SizedBox(width: 6),
                                Text(
                                  'Coordinates: ${_detectedLocation!.displayCoordinates}',
                                  style: GoogleFonts.dmSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.ink,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Detected Area: ${_detectedLocation!.formattedRegion}',
                              style: GoogleFonts.dmSans(
                                fontSize: 11,
                                color: AppColors.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _isDetectingGps ? null : _detectGpsLocation,
                        icon: _isDetectingGps
                            ? const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.ink,
                                ),
                              )
                            : const Icon(Icons.my_location, size: 16, color: AppColors.ink),
                        label: Text(
                          _isDetectingGps
                              ? 'Acquiring GPS Fix...'
                              : 'Detect GPS Location',
                          style: GoogleFonts.dmSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.ink,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.ink),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Manual Section Divider
              Row(
                children: [
                  Expanded(child: Container(height: 1, color: AppColors.line)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'OR SELECT MANUALLY',
                      style: GoogleFonts.dmSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: AppColors.muted,
                      ),
                    ),
                  ),
                  Expanded(child: Container(height: 1, color: AppColors.line)),
                ],
              ),
              const SizedBox(height: 20),

              // Form: Province
              _buildFieldLabel('Province'),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.paper,
                  border: Border.all(color: AppColors.line),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedProvince,
                    hint: Text(
                      'Choose province',
                      style: GoogleFonts.dmSans(fontSize: 14, color: AppColors.muted),
                    ),
                    items: _provinceCities.keys.map((p) {
                      return DropdownMenuItem<String>(
                        value: p,
                        child: Text(
                          p,
                          style: GoogleFonts.dmSans(fontSize: 14, color: AppColors.ink),
                        ),
                      );
                    }).toList(),
                    onChanged: _onProvinceChanged,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Form: City / Regency
              _buildFieldLabel('City / Regency'),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.paper,
                  border: Border.all(color: AppColors.line),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: availableCities.contains(_selectedCity) ? _selectedCity : null,
                    hint: Text(
                      _selectedProvince == null
                          ? 'Choose province first'
                          : 'Choose city / regency',
                      style: GoogleFonts.dmSans(fontSize: 14, color: AppColors.muted),
                    ),
                    items: availableCities.map((c) {
                      return DropdownMenuItem<String>(
                        value: c,
                        child: Text(
                          c,
                          style: GoogleFonts.dmSans(fontSize: 14, color: AppColors.ink),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedCity = val;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Scope
              _buildFieldLabel('Leaderboard Scope'),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.paper,
                  border: Border.all(color: AppColors.line),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _regionScope,
                    items: const [
                      DropdownMenuItem(
                        value: 'City / Regency',
                        child: Text('City / Regency'),
                      ),
                      DropdownMenuItem(
                        value: 'Province',
                        child: Text('Province'),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _regionScope = val;
                        });
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'This setting adjusts your regional leaderboard view and ranking filter.',
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  color: AppColors.muted,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveRegion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.dark,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Save region',
                        style: GoogleFonts.dmSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.arrow_forward, size: 14, color: Colors.white),
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

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.dmSans(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.ink,
      ),
    );
  }
}
