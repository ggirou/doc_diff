import "dart:io";
import "dart:collection";
import "dart:isolate";
import "dart:async";
import "dart:mirrors";
import "packages/unittest/unittest.dart";
import "packages/unittest/mock.dart";
import "packages/unittest/matcher.dart";

import "dart:json" as JSON;

void main() {
  // kind: (constructor|param|class|method|functiontype|property|variable|typeparam|library)
  
  var firstDocFile = "../jsondocs/23799/dart.io.json";
  var secondDocFile = "../jsondocs/25017/dart.io.json";
  
  Map firstDoc = filterAndTransform(parseJsonFile(firstDocFile));
  Map secondDoc = filterAndTransform(parseJsonFile(secondDocFile));

//  print(firstDoc);
//  prettyPrint(filterAndTransform(firstDoc), stdout);

  var result = compare(firstDoc, secondDoc);
  // TODO: compare2 by children & dependencies
  prettyPrint(result, stdout);
//  htmlPrint(result, stdout);
//  htmlPrint2(result, stdout);
}

parseJsonFile(String filePath) => JSON.parse(new File(filePath).readAsStringSync());

final excludeField = ["comment", "line", "children", "dependencies", "isPrivate"];  

filterAndTransform(value) {
  if(value is Map) {
    Map result = new Map();
    value.keys.where((k) => !excludeField.contains(k)).forEach((k) => result[k] = value[k]);
    if(value["children"] is List) {
      result["children"] = filterAndTransform(value["children"]);
    }
    if(value["dependencies"] is List) {
      result["dependencies"] = filterAndTransform(value["dependencies"]);
    }
    return result;
  } else if (value is List) {
    var children = value.where((v) => v["isPrivate"] != true).map(filterAndTransform);
    return new Map.fromIterable(children, key: (Map m) => m["id"]);
  } else {
    return value;
  }
}

//jsonFilter(key, value) => ["comment", "line"].contains(key) ? "" : value;

compare2(first, second) {
}

compare(first, second) {
  if(first is List && second is List) {
    return compareLists(first, second);
  } else if(first is Map && second is Map) {
    return compareMaps(first, second);
  } else {
    if(first == second) {
      return null;
    } else {
      return new Map()
      ..["-"] = first
      ..["+"] = second;
    }
  }
}

Map compareMaps(Map first, Map second) {
  Map result = new Map();
  var keys = new Set()..addAll(first.keys)..addAll(second.keys);
  keys.forEach((k) {
    var cmp = compare(first[k], second[k]);
    if(cmp is Map && cmp.keys.toSet().containsAll(["-", "+"])) {
      if(cmp["-"] != null) {
        result["-$k"] = cmp["-"];
      }
      if(cmp["+"] != null) {
        result["+$k"] = cmp["+"];
      }
    } else if(cmp != null && !(cmp is Map && cmp.isEmpty)) {
      result[k] = cmp;
    } else if (k == "name") {
      result["name"] = first[k];
    }
  });
  return result;
}

compareLists(List first, List second) => compareMaps(docListToMap(first), docListToMap(second));

docListToMap(list) => new Map.fromIterable(list, key: (Map m) => m["id"]);

String prettyPrint(Map m, StringSink output, {String prefix: ""}) {
  var newPrefix = "$prefix  ";
  output.write("$prefix{\n");
  m.forEach((k, v) {
    output.write("$newPrefix$k: ");
    if(v is Map) {
      prettyPrint(v, output, prefix: newPrefix);
    } else if (v is List) {
      output.write("[\n");
      v.forEach((i) {
        prettyPrint(i, output, prefix: "$newPrefix  ");
        output.write(",\n");
      });
      output.write("$newPrefix]");
    } else {
      output.write(v);
    }
    output.write(",\n");
  });
  output.write("$prefix}");
}

String htmlPrint(value, StringSink output, {String prefix: ""}) {
  if(value is Map) {
    output.write("\n$prefix<ul>\n");
    value.forEach((k, v) {
      output.write("$prefix<li>$k:");
      htmlPrint(v, output, prefix: "$prefix  ");
      output.write("</li>\n");
    });
    output.write("$prefix</ul>");
  } else {
    output.write(value);
  }
}

String htmlPrint2(Map value, StringSink output, {String prefix: "", String style: ""}) {
  output.write("$prefix<li style='$style'>${value['name']}</li>\n");
  if(value['children'] is Map) {
    output.write("$prefix<ul>\n");
    value['children'].forEach((k, v) {
      String style= k.startsWith("-") ? "text-decoration: line-through;" 
          : (k.startsWith("+") ? "font-weight: bold;" : "font-style: italic;");
      htmlPrint2(v, output, prefix: "$prefix  ", style: style);
    });
    output.write("$prefix</ul>\n");
  }
}