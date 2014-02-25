part of docdiff;

/**
 * Base class for all elements in the AST.
 */
class Element implements JsonSerializable {
  /** Human readable type name for the node. */
  final String kind;
  /** Human readable name for the element. */
  final String name;
  /** Id for the node that is unique within its parent's children. */
  final String id;
  /** Raw text of the comment associated with the Element if any. */
  final String comment;
  /** Raw html comment for the Element from MDN. */
  final String mdnCommentHtml;
  /**
   * The URL to the page on MDN that content was pulled from for the current
   * type being documented. Will be `null` if the type doesn't use any MDN
   * content.
   */
  final String mdnUrl;
  /** Children of the node. */
  final Set<Element> children;
  /** Whether the element is private. */
  final bool isPrivate;

  /**
   * Uri containing the definition of the element.
   */
  final String uri;
  /**
   * Line in the original source file that starts the definition of the element.
   */
  final String line;
  
  Element._fromJson(Map<String, Object> values) :
    kind = values["kind"],
    name = values["name"],
    id = values["id"],
    comment = values["comment"],
    mdnCommentHtml = values["mdnCommentHtml"],
    mdnUrl = values["mdnUrl"],
    isPrivate = values["isPrivate"],
    uri = values["uri"],
    line = values["line"],
    children = _jsonListToIterable(values["children"], (v) => new Element.fromJson(v)).toSet();
  
  factory Element.fromJson(Map<String, Object> values, {ignorePrivate: true}) {
    if(ignorePrivate && values["isPrivate"] == true) {
      return null;
    }
    
    var kind = values["kind"];
    if(kind == "library") {
      return new LibraryElement.fromJson(values);
    } else if(kind == "class") {
      return new ClassElement.fromJson(values);
    } else if(kind == "property") {
      return new GetterElement.fromJson(values);
    } else if(kind == "method" || kind == "constructor") {
      return new MethodElement.fromJson(values);
    } else if(kind == "param") {
      return new ParameterElement.fromJson(values);
    } else if(kind == "functiontype") {
      return new FunctionTypeElement.fromJson(values);
    } else if(kind == "typeparam") {
      return new TypeParameterElement.fromJson(values);
    } else if(kind == "variable") {
      return new VariableElement.fromJson(values);
    } else if(kind == "?????") {
      return new TypedefElement.fromJson(values);
    } else {
      print("Unknown kind: $kind");
      return new Element._fromJson(values);
    }
  }
  
  String get key => id;
  Element operator [](String key) => 
      children.firstWhere((e) => e.key == key, orElse: () => null);

  int get hashCode => key.hashCode;
  bool operator ==(other) => other != null 
      && this.runtimeType == other.runtimeType
      && this.key == other.key;
  String toString() => "$runtimeType($name)";
  
  Map<String, Object> toJson() => {
    "kind": kind,
    "name": name,
    "id": id,
    "comment": comment,
    "mdnCommentHtml": mdnCommentHtml,
    "mdnUrl": mdnUrl,
    "isPrivate": isPrivate,
    "uri": uri,
    "line": line,
    "children": children.map((c) => c.toJson()).toList(),
  };
}

/**
 * [Element] describing a Dart library.
 */
class LibraryElement extends Element {
  /**
   * Partial versions of LibraryElements containing classes that are extended
   * or implemented by classes in this library.
   */
  final Set<LibraryElement> dependencies;

  LibraryElement.fromJson(Map<String, Object> values) : 
    super._fromJson(values),
    dependencies = _jsonListToIterable(values["dependencies"], (v) => new LibraryElement.fromJson(v)).toSet();

  Map<String, Object> toJson() => super.toJson()..addAll({
    "dependencies": dependencies.map((c) => c.toJson()).toList(),
  });
}

/**
 * [Element] describing a Dart class.
 */
class ClassElement extends Element {
  /** Base class.*/
  final Reference superclass;
  /** Whether the class is abstract. */
  final bool isAbstract;
  /** Interfaces the class implements. */
  final List<Reference> interfaces;
  /** Whether the class implements or extends [Error] or [Exception]. */
  final bool isThrowable;

  ClassElement.fromJson(Map<String, Object> values) : 
    super._fromJson(values),
    isAbstract = values["isAbstract"],
    isThrowable = values["isThrowable"],
    superclass = new Reference.fromJson(values["superclass"]),
    interfaces = _jsonListToIterable(values["interfaces"], (v) => new Reference.fromJson(v)).toList();

  Map<String, Object> toJson() => super.toJson()..addAll({
    "superclass": superclass,
    "isAbstract": isAbstract,
    "isThrowable": isThrowable,
    "interfaces": interfaces.map((c) => c.toJson()).toList(),
  });
}

/**
 * [Element] describing a getter.
 */
class GetterElement extends Element {
  /** Type of the getter. */
  final Reference ref;
  final bool isStatic;

  GetterElement.fromJson(Map<String, Object> values) : 
    super._fromJson(values),
    isStatic = values["isStatic"],
    ref = new Reference.fromJson(values["ref"]);

  Map<String, Object> toJson() => super.toJson()..addAll({
    "isStatic": isStatic,
    "ref": _toJson(ref),
  });
}

/**
 * [Element] describing a method which may be a regular method, a setter, or an
 * operator.
 */
class MethodElement extends Element {
  final Reference returnType;
  final bool isSetter;
  final bool isOperator;
  final bool isStatic;

  MethodElement.fromJson(Map<String, Object> values) : 
    super._fromJson(values),
    isSetter = values["isSetter"],
    isOperator = values["isOperator"],
    isStatic = values["isStatic"],
    returnType = new Reference.fromJson(values["returnType"]);

  Map<String, Object> toJson() => super.toJson()..addAll({
    "isSetter": isSetter,
    "isOperator": isOperator,
    "isStatic": isStatic,
    "returnType": _toJson(returnType),
  });
  
  String get key => name;
}

/**
 * Element describing a parameter.
 */
class ParameterElement extends Element {
  /** Type of the parameter. */
  final Reference ref;

  /**
   * Returns the default value for this parameter.
   */
  final String defaultValue;

  /**
   * Is this parameter optional?
   */
  final bool isOptional;

  /**
   * Is this parameter named?
   */
  final bool isNamed;

  /**
   * Returns the initialized field, if this parameter is an initializing formal.
   */
  final Reference initializedField;

  ParameterElement.fromJson(Map<String, Object> values) : 
    super._fromJson(values),
    defaultValue = values["defaultValue"],
    isOptional = values["isOptional"],
    isNamed = values["isNamed"],
    ref = new Reference.fromJson(values["ref"]),
    initializedField = new Reference.fromJson(values["initializedField"]);

  Map<String, Object> toJson() => super.toJson()..addAll({
    "defaultValue": defaultValue,
    "isOptional": isOptional,
    "isNamed": isNamed,
    "ref": _toJson(ref),
    "initializedField": _toJson(initializedField),
  });
}

class FunctionTypeElement extends Element {
  final Reference returnType;

  FunctionTypeElement.fromJson(Map<String, Object> values) : 
    super._fromJson(values),
    returnType = new Reference.fromJson(values["returnType"]);

  Map<String, Object> toJson() => super.toJson()..addAll({
    "returnType": _toJson(returnType),
  });
}

/**
 * Element describing a generic type parameter.
 */
class TypeParameterElement extends Element {
  /**
   * Upper bound for the parameter.
   *
   * In the following code sample, [:Bar:] is an upper bound:
   * [: class Bar<T extends Foo> { } :]
   */
  final Reference upperBound;

  TypeParameterElement.fromJson(Map<String, Object> values) : 
    super._fromJson(values),
    upperBound = new Reference.fromJson(values["upperBound"]);

  Map<String, Object> toJson() => super.toJson()..addAll({
    "upperBound": _toJson(upperBound),
  });
}

/**
 * Element describing a variable.
 */
class VariableElement extends Element {
  /** Type of the variable. */
  final Reference ref;
  /** Whether the variable is static. */
  final bool isStatic;
  /** Whether the variable is final. */
  final bool isFinal;

  VariableElement.fromJson(Map<String, Object> values) : 
    super._fromJson(values),
    isStatic = values["isStatic"],
    isFinal = values["isFinal"],
    ref = new Reference.fromJson(values["ref"]);

  Map<String, Object> toJson() => super.toJson()..addAll({
    "isStatic": isStatic,
    "isFinal": isFinal,
    "ref": _toJson(ref),
  });
}

/**
 * Element describing a typedef.
 */

class TypedefElement extends Element {
  /** Return type of the typedef. */
  final Reference returnType;

  TypedefElement.fromJson(Map<String, Object> values) : 
    super._fromJson(values),
    returnType = new Reference.fromJson(values["returnType"]);

  Map<String, Object> toJson() => super.toJson()..addAll({
    "returnType": _toJson(returnType),
  });
}

/**
 * Reference to an Element with type argument if the reference is parameterized.
 */
class Reference implements JsonSerializable {
  final String name;
  final String refId;
  final List<Reference> arguments;
  
  Reference._fromJson(Map<String, Object> values) : 
    name = values["name"],
    refId = values["refId"],
    arguments = _jsonListToIterable(values["arguments"], (v) => new Reference.fromJson(v)).toList();
  
  factory Reference.fromJson(Map<String, Object> values) => 
      values == null ? null : new Reference._fromJson(values); 

  Map<String, Object> toJson() => {
    "name": name,
    "refId": refId,
    "arguments": arguments.map((c) => c.toJson()).toList(),
  };
}

Iterable _jsonListToIterable(List<Map<String, Object>> valuesList, f(Map<String, Object> values)) => 
    (valuesList == null ? [] : valuesList.map(f).where((e) => e != null));
