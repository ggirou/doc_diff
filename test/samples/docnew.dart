library docexample;

var toplevelVariable;
//var deletedToplevelVariable;
var addedToplevelVariable;

int toplevelFunction(String a, {optional}) => null;
//int deletedToplevelFunction(String a, {optional}) => null;
int addedToplevelFunction(String a, {optional}) => null;

class _Annotation { const _Annotation(); }
const Object annotation = const _Annotation();
//const Object deletedAnnotation = const _Annotation();
const Object addedAnnotation = const _Annotation();

class Class {
  var variable;
  //var deletedVariable;
  var addedVariable;
  
  Class();
  //Class.deleted();
  Class.added();

  int function(String a, {optional}) => null;
  //int deletedFunction(String a, {optional}) => null;
  int addedFunction(String a, {optional}) => null;

  int parameters(String a, int b, {c}) => null;
  //int deletedParameters(String a, int b, {c}) => null;
  int addedParameters(String a, int b, {c}) => null;
}

class SameClass {}
//class DeletedClass {}
class AddedClass {}

class GenericClass<A, B, C> {}
class DeletedGenericClass<A, B> {}
class AddedGenericClass<A, B, C> {}
