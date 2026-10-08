class Project {
  final int? id;
  String name, client, address, phone;
  Project({this.id, required this.name, this.client = '', this.address = '', this.phone = ''});
}

class Place {
  final int? id;
  final int projectId;
  String name;
  Place({this.id, required this.projectId, required this.name});
}

class MaterialItem {
  final int? id;
  final int projectId;
  int placeId;
  String name, spec, unit, notes;
  double quantity;
  MaterialItem({this.id, required this.projectId, required this.placeId, required this.name, required this.spec, required this.unit, required this.quantity, this.notes = ''});
}

class CatalogMaterial {
  final int? id;
  String name, spec, unit;
  CatalogMaterial({this.id, required this.name, required this.spec, required this.unit});
}

class GroupedMaterial {
  final String name, spec, unit;
  double quantity;
  final Set<int> placeIds;
  GroupedMaterial({required this.name, required this.spec, required this.unit, required this.quantity, Set<int>? placeIds}) : placeIds = placeIds ?? {};
}

List<GroupedMaterial> groupMaterials(Iterable<MaterialItem> items) {
  final map = <String, GroupedMaterial>{};
  for (final item in items) {
    final key = '${item.name.trim().toLowerCase()}|${item.spec.trim().toLowerCase()}|${item.unit.trim().toLowerCase()}';
    final current = map.putIfAbsent(key, () => GroupedMaterial(name: item.name.trim(), spec: item.spec.trim(), unit: item.unit.trim(), quantity: 0));
    current.quantity += item.quantity;
    current.placeIds.add(item.placeId);
  }
  return map.values.toList();
}
