import regex

type
  nre_regex_match_t = object

proc nre_match(s: cstring, pattern: cstring, m: ptr nre_regex_match_t): c_int {.exportc.} =
  var rm = cast[ptr RegexMatch](m)
  if match($s, re($pattern), rm[]):
    return 1
  else:
    return 0
