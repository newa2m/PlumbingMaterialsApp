import 'package:flutter_test/flutter_test.dart';
import 'package:plumbing_takeoff/models.dart';
void main() { test('يجمع الاسم والمقاس والوحدة المتطابقة فقط', () { final xs = [MaterialItem(projectId: 1, placeId: 1, name: ' كوع ', spec: '25 مم', unit: 'قطعة', quantity: 8), MaterialItem(projectId: 1, placeId: 2, name: 'كوع', spec: '25 مم', unit: 'قطعة', quantity: 6), MaterialItem(projectId: 1, placeId: 1, name: 'كوع', spec: '32 مم', unit: 'قطعة', quantity: 3)]; final g = groupMaterials(xs); expect(g.length, 2); expect(g.first.quantity, 14); }); }
