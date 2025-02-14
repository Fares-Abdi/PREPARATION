import 'package:flutter/material.dart';
import '../../widgets/advanced_drawing_canvas.dart';

class DrawingSession {
  final String id;
  final String creatorId;
  final DateTime createdAt;
  List<SerializableDrawingPoint?> points;

  DrawingSession({
    required this.id,
    required this.creatorId,
    required this.createdAt,
    required this.points,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'creatorId': creatorId,
    'createdAt': createdAt.toIso8601String(),
    'points': points.map((p) => p?.toJson()).toList(),
  };

  factory DrawingSession.fromJson(Map<String, dynamic> json) {
    return DrawingSession(
      id: json['id'],
      creatorId: json['creatorId'],
      createdAt: DateTime.parse(json['createdAt']),
      points: (json['points'] as List)
          .map((p) => p != null ? SerializableDrawingPoint.fromJson(p) : null)
          .toList(),
    );
  }
}

class SerializableDrawingPoint {
  final double x;
  final double y;
  final double strokeWidth;
  final int color;
  final String? shape;
  final double? endX;
  final double? endY;
  final bool isFilled;

  SerializableDrawingPoint({
    required this.x,
    required this.y,
    required this.strokeWidth,
    required this.color,
    this.shape,
    this.endX,
    this.endY,
    this.isFilled = false,
  });

  Map<String, dynamic> toJson() => {
    'x': x,
    'y': y,
    'strokeWidth': strokeWidth,
    'color': color,
    'shape': shape,
    'endX': endX,
    'endY': endY,
    'isFilled': isFilled,
  };

  factory SerializableDrawingPoint.fromJson(Map<String, dynamic> json) {
    return SerializableDrawingPoint(
      x: json['x'].toDouble(),
      y: json['y'].toDouble(),
      strokeWidth: json['strokeWidth'].toDouble(),
      color: json['color'],
      shape: json['shape'],
      endX: json['endX']?.toDouble(),
      endY: json['endY']?.toDouble(),
      isFilled: json['isFilled'] ?? false,
    );
  }

  DrawingPoint toDrawingPoint() {
    return DrawingPoint(
      offset: Offset(x, y),
      paint: Paint()
        ..color = Color(color)
        ..strokeWidth = strokeWidth
        ..style = isFilled ? PaintingStyle.fill : PaintingStyle.stroke,
      shape: shape,
      endOffset: endX != null && endY != null ? Offset(endX!, endY!) : null,
    );
  }
}
