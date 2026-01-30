import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../../core/styles.dart';
import '../../domain/land_boundary.dart';
import '../../data/land_repository.dart';

class LandMapScreen extends StatefulWidget {
  const LandMapScreen({Key? key}) : super(key: key);

  @override
  State<LandMapScreen> createState() => _LandMapScreenState();
}

class _LandMapScreenState extends State<LandMapScreen> {
  GoogleMapController? _mapController;
  final LandRepository _repository = LandRepository();
  List<LandBoundary> _lands = [];
  Set<Polygon> _polygons = {};
  Set<Marker> _markers = {};
  LatLng? _currentLocation;
  bool _isLoading = true;
  bool _isDrawingMode = false;
  List<LatLng> _drawingPoints = [];

  // Default location: Morocco (Rabat)
  static const LatLng _defaultLocation = LatLng(33.9716, -6.8498);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _getCurrentLocation();
    await _loadLands();
    setState(() => _isLoading = false);
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _currentLocation = _defaultLocation);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _currentLocation = _defaultLocation);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() => _currentLocation = _defaultLocation);
        return;
      }

      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      setState(() => _currentLocation = _defaultLocation);
    }
  }

  Future<void> _loadLands() async {
    final lands = await _repository.getAllLands();
    setState(() {
      _lands = lands;
    });
    _updateMapOverlays();
  }

  void _updateMapOverlays() {
    final Set<Polygon> newPolygons = {};
    final Set<Marker> newMarkers = {};

    for (var land in _lands) {
      // Add polygon
      newPolygons.add(
        Polygon(
          polygonId: PolygonId(land.id),
          points: land.coordinates,
          strokeColor: AppStyles.primaryGreen,
          strokeWidth: 3,
          fillColor: AppStyles.primaryGreen.withOpacity(0.2),
          onTap: () => _showLandDetails(land),
        ),
      );

      // Add marker at center
      newMarkers.add(
        Marker(
          markerId: MarkerId(land.id),
          position: land.center,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: InfoWindow(
            title: land.name,
            snippet: '${land.areaInHectares.toStringAsFixed(2)} هكتار',
          ),
          onTap: () => _showLandDetails(land),
        ),
      );
    }

    setState(() {
      _polygons = newPolygons;
      _markers = newMarkers;
    });
  }

  void _showLandDetails(LandBoundary land) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.landscape, color: AppStyles.primaryGreen, size: 32),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    land.name,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildDetailRow(Icons.square_foot, 'المساحة', '${land.areaInHectares.toStringAsFixed(2)} هكتار'),
            SizedBox(height: 12),
            _buildDetailRow(Icons.location_on, 'الإحداثيات', '${land.center.latitude.toStringAsFixed(4)}, ${land.center.longitude.toStringAsFixed(4)}'),
            if (land.notes != null && land.notes!.isNotEmpty) ...[
              SizedBox(height: 12),
              _buildDetailRow(Icons.notes, 'ملاحظات', land.notes!),
            ],
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _editLand(land);
                    },
                    icon: Icon(Icons.edit),
                    label: Text('تعديل'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppStyles.primaryGreen,
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _deleteLand(land);
                    },
                    icon: Icon(Icons.delete),
                    label: Text('حذف'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppStyles.primaryGreen, size: 20),
        SizedBox(width: 8),
        Text('$label: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Expanded(child: Text(value, style: TextStyle(fontSize: 16))),
      ],
    );
  }

  void _editLand(LandBoundary land) {
    // TODO: Implement edit functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('ميزة التعديل قريباً')),
    );
  }

  void _deleteLand(LandBoundary land) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف ${land.name}؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _repository.deleteLand(land.id);
      await _loadLands();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم حذف ${land.name}')),
      );
    }
  }

  void _toggleDrawingMode() {
    setState(() {
      _isDrawingMode = !_isDrawingMode;
      if (!_isDrawingMode && _drawingPoints.isNotEmpty) {
        _saveNewLand();
      }
      _drawingPoints.clear();
    });
  }

  void _saveNewLand() async {
    if (_drawingPoints.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('يجب تحديد 3 نقاط على الأقل')),
      );
      return;
    }

    final nameController = TextEditingController();
    final notesController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('أضف أرض جديدة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'اسم الأرض',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: notesController,
              decoration: InputDecoration(
                labelText: 'ملاحظات (اختياري)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('حفظ'),
            style: ElevatedButton.styleFrom(backgroundColor: AppStyles.primaryGreen),
          ),
        ],
      ),
    );

    if (result == true && nameController.text.isNotEmpty) {
      final newLand = LandBoundary.create(
        name: nameController.text,
        coordinates: List.from(_drawingPoints),
        notes: notesController.text.isEmpty ? null : notesController.text,
      );

      await _repository.saveLand(newLand);
      await _loadLands();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم حفظ ${newLand.name}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show a message for web platform about Google Maps API key requirement
    if (kIsWeb) {
      return Scaffold(
        appBar: AppBar(
          title: Text('خريطة الأراضي', style: AppStyles.headerTitle.copyWith(color: Colors.white)),
          backgroundColor: AppStyles.primaryGreen,
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.map, size: 80, color: AppStyles.primaryGreen),
                SizedBox(height: 24),
                Text(
                  'خريطة الأراضي',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Text(
                  'لاستخدام ميزة الخريطة على الويب، يجب إضافة Google Maps API Key',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12),
                Text(
                  'هذه الميزة متاحة بالكامل على تطبيق الهاتف (Android/iOS)',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppStyles.primaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline, color: AppStyles.primaryGreen),
                          SizedBox(width: 8),
                          Text(
                            'المميزات:',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      _buildFeatureItem('رسم حدود الأرض الفلاحية'),
                      _buildFeatureItem('حساب المساحة تلقائياً'),
                      _buildFeatureItem('تحديد الموقع الحالي'),
                      _buildFeatureItem('إدارة عدة أراضي'),
                      _buildFeatureItem('ملخص شامل للمساحات'),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back),
                  label: Text('رجوع', style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppStyles.primaryGreen,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('خريطة الأراضي', style: AppStyles.headerTitle.copyWith(color: Colors.white)),
          backgroundColor: AppStyles.primaryGreen,
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('خريطة الأراضي', style: AppStyles.headerTitle.copyWith(color: Colors.white)),
        backgroundColor: AppStyles.primaryGreen,
        actions: [
          IconButton(
            icon: Icon(_isDrawingMode ? Icons.check : Icons.draw),
            onPressed: _toggleDrawingMode,
            tooltip: _isDrawingMode ? 'حفظ' : 'رسم حدود',
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentLocation ?? _defaultLocation,
              zoom: 15,
            ),
            onMapCreated: (controller) => _mapController = controller,
            polygons: _polygons,
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            mapType: MapType.hybrid,
            onTap: _isDrawingMode ? (point) {
              setState(() {
                _drawingPoints.add(point);
              });
            } : null,
            polylines: _isDrawingMode && _drawingPoints.isNotEmpty
                ? {
                    Polyline(
                      polylineId: PolylineId('drawing'),
                      points: _drawingPoints,
                      color: Colors.blue,
                      width: 3,
                    ),
                  }
                : {},
          ),
          if (_isDrawingMode)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppStyles.primaryGreen,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.touch_app, color: Colors.white),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'انقر على الخريطة لتحديد حدود الأرض (${_drawingPoints.length} نقاط)',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (_drawingPoints.isNotEmpty)
                      IconButton(
                        icon: Icon(Icons.undo, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            if (_drawingPoints.isNotEmpty) {
                              _drawingPoints.removeLast();
                            }
                          });
                        },
                      ),
                  ],
                ),
              ),
            ),
          if (_lands.isEmpty && !_isDrawingMode)
            Positioned(
              bottom: 100,
              left: 20,
              right: 20,
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(Icons.landscape, size: 48, color: AppStyles.primaryGreen),
                    SizedBox(height: 12),
                    Text(
                      'لا توجد أراضي محفوظة',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'اضغط على أيقونة الرسم لإضافة أول أرض',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: !_isDrawingMode && _lands.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () {
                // Show summary of all lands
                _showLandsSummary();
              },
              backgroundColor: AppStyles.primaryGreen,
              icon: Icon(Icons.assessment),
              label: Text('الملخص'),
            )
          : null,
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: AppStyles.primaryGreen, size: 20),
          SizedBox(width: 8),
          Expanded(child: Text(text, style: TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  void _showLandsSummary() {
    double totalArea = _lands.fold(0, (sum, land) => sum + land.areaInHectares);
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.assessment, color: AppStyles.primaryGreen, size: 32),
                SizedBox(width: 12),
                Text(
                  'ملخص الأراضي',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppStyles.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('عدد الأراضي:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('${_lands.length}', style: TextStyle(fontSize: 18)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('المساحة الإجمالية:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('${totalArea.toStringAsFixed(2)} هكتار', style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text('الأراضي:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            ...(_lands.map((land) => Card(
              margin: EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Icon(Icons.landscape, color: AppStyles.primaryGreen),
                title: Text(land.name),
                subtitle: Text('${land.areaInHectares.toStringAsFixed(2)} هكتار'),
                onTap: () {
                  Navigator.pop(context);
                  _showLandDetails(land);
                },
              ),
            ))),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
