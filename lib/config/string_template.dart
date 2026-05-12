/// Replaces `{{key}}` placeholders in [template] using [vars].
String applyTemplate(String template, Map<String, String> vars) {
  var out = template;
  for (final e in vars.entries) {
    out = out.replaceAll('{{${e.key}}}', e.value);
  }
  return out;
}
