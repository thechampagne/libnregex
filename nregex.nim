import regex

type
  nre_regex_match_t = object

proc nre_regex_match_init(): ptr nre_regex_match_t {.exportc.} =
  let rm = create RegexMatch
  return cast[ptr nre_regex_match_t](rm)

proc nre_match(s: cstring, pattern: cstring, m: ptr nre_regex_match_t): c_int {.exportc.} =
  var rm = cast[ptr RegexMatch](m)
  if match($s, re($pattern), rm[]):
    return 1
  else:
    return 0

proc nre_is_match(s: cstring, pattern: cstring): c_int {.exportc.} =
  if match($s, re($pattern)):
    return 1
  else:
    return 0

