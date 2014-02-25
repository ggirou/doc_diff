part of docdiff;

class DocComparator implements JsonSerializable {
  final Element from;
  final Element to;
  final Set<Element> addedChildren;
  final Set<Element> removedChildren;
  final List<DocComparator> children;
  bool isSame;

  DocComparator._(from, to) :
    from = from,
    to = to,
    addedChildren = to.children.difference(from.children),
    removedChildren = from.children.difference(to.children),
    children = to.children.intersection(from.children)
        .map((c) => new DocComparator(from[c.key], to[c.key]))
        .toList() {
    isSame = addedChildren.isEmpty && removedChildren.isEmpty && children.every((e) => e.isSame);
  }
  
  factory DocComparator(from, to) => new DocComparator._(from, to);
  
  Map<String, Object> toJson() => to.toJson()..addAll({
    "status": isSame ? "same" : "changed",
    "children": []..addAll(removedChildren.map(_toJson).map(_withStatus("removed")).map(_jsonEmptyChildren))
                  ..addAll(addedChildren.map(_toJson).map(_withStatus("added")))
                  ..addAll(children.map((c) => c.toJson()))
                  ..sort((a, b) => a["id"].compareTo(b["id"])),
  });
}

_withStatus(String status) => (Map json) => json..["status"] = status;

Map _jsonEmptyChildren(Map json) => json..["children"] = const [];
  
