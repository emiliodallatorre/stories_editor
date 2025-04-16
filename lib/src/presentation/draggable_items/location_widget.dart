import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stories_editor/src/domain/models/geo_point.dart';

class LocationWidget extends StatelessWidget {
  /// The geographic location to display
  final GeoPoint location;

  /// Whether this location widget is mandatory (for "last" content)
  final bool isMandatory;

  /// Create a new location widget
  const LocationWidget({
    Key? key,
    required this.location,
    this.isMandatory = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Scaling factors for mandatory location widgets
    final double scaleFactor = isMandatory ? 1.3 : 1.0;
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.w * scaleFactor, 
        vertical: 8.h * scaleFactor
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(isMandatory ? 0.7 : 0.6),
        borderRadius: BorderRadius.circular(16.r * scaleFactor),
        border: isMandatory ? Border.all(color: Colors.white.withOpacity(0.3), width: 1) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.location_on,
            color: Colors.white,
            size: 18.sp * scaleFactor,
          ),
          SizedBox(width: 6.w * scaleFactor),
          Text(
            location.locationName,
            style: TextStyle(
              color: Colors.white,
              fontWeight: isMandatory ? FontWeight.w600 : FontWeight.w500,
              fontSize: 14.sp * scaleFactor,
              letterSpacing: isMandatory ? 0.5 : 0.0,
            ),
          ),
        ],
      ),
    );
  }
}
