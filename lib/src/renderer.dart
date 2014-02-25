part of docdiff;

abstract class Renderer {
  final StringSink _output;
  
  Renderer._(this._output);
  
  render(DocComparator comp);
}

class JsonRender extends Renderer {
  JsonRender(StringSink output) : super._(output);

  render(DocComparator comp) =>
      _renderJson(comp.toJson());
  
  _renderJson(Map<String, Object> value, {String prefix: ""}) {
    var newPrefix = "$prefix  ";
    _output.write("$prefix{\n");
    value.forEach((k, v) {
      _output.write("$newPrefix$k: ");
      if(v is Map) {
        _renderJson(v, prefix: newPrefix);
      } else if (v is List) {
        _output.write("[\n");
        v.forEach((i) {
          _renderJson(i, prefix: "$newPrefix  ");
          _output.write(",\n");
        });
        _output.write("$newPrefix]");
      } else {
        _output.write(v);
      }
      _output.write(",\n");
    });
    _output.write("$prefix}");
  }
}

const _statusStyles = const {
  null: "",
  "same": "",
  "removed": "text-decoration: line-through;",
  "added": "font-weight: bold;",
  "changed": "font-style: italic;",
};

class SimpleHtmlRender extends Renderer {
  SimpleHtmlRender(StringSink output) : super._(output);

  render(DocComparator comp) =>
      _renderJsonToHtml(comp.toJson());
  
  _renderJsonToHtml(Map<String, Object> value, {String prefix: ""}) {
    if(value["status"] != "same") {
      var style = _statusStyles[value["status"]];
      _output.write("$prefix<li id='${value['id']}' style='$style'>${value['name']}</li>\n");
      
      List children = (value['children'] as Iterable).where((c) => c["status"] != "same").toList();
      if(!children.isEmpty) {
        _output.write("$prefix<ul>\n");
        children.forEach((c) {
          _renderJsonToHtml(c, prefix: "$prefix  ");
        });
        _output.write("$prefix</ul>\n");
      }
    }
  }
}