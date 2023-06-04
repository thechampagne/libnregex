import regex

type
  nre_regex_t = object
  nre_regex_match_t = object

proc nre_regex_compile(s: cstring): ptr nre_regex_t {.exportc.} =
  let r = create Regex
  r[] = re($s)
  return cast[ptr nre_regex_t](r)

proc nre_regex_match_init(): ptr nre_regex_match_t {.exportc.} =
  let rm = create RegexMatch
  return cast[ptr nre_regex_match_t](rm)

proc nre_match(s: cstring, pattern: ptr nre_regex_t, m: ptr nre_regex_match_t): c_int {.exportc.} =
  let r = cast[ptr Regex](pattern)
  var rm = cast[ptr RegexMatch](m)
  if match($s, r[], rm[]):
    return 1
  else:
    return 0

proc nre_is_match(s: cstring, pattern: ptr nre_regex_t): c_int {.exportc.} =
  let r = cast[ptr Regex](pattern)
  if match($s, r[]):
    return 1
  else:
    return 0

proc nre_contains(s: cstring, pattern: ptr nre_regex_t): cint {.exportc.} =
  let r = cast[ptr Regex](pattern)
  if contains($s, r[]):
    return 1
  else:
    return 0

proc nre_starts_with(s: cstring, pattern: ptr nre_regex_t, start: csize_t): cint {.exportc.} =
  let r = cast[ptr Regex](pattern)
  if startsWith($s, r[], int(start)):
    return 1
  else:
    return 0

proc nre_ends_with(s: cstring, pattern: ptr nre_regex_t): cint {.exportc.} =
  let r = cast[ptr Regex](pattern)
  if endsWith($s, r[]):
    return 1
  else:
    return 0

proc nre_find(s: cstring, pattern: ptr nre_regex_t, m: ptr nre_regex_match_t, start: csize_t): cint {.exportc.} =
  let r = cast[ptr Regex](pattern)
  var rm = cast[ptr RegexMatch](m)
  if find($s, r[], rm[], int(start)):
    return 1
  else:
    return 0


# TODOs:
# func group(m: RegexMatch; i: int; text: string): seq[string]
# func groupFirstCapture(m: RegexMatch; i: int; text: string): string
# func groupLastCapture(m: RegexMatch; i: int; text: string): string
# func group(m: RegexMatch; groupName: string; text: string): seq[string]
# func groupFirstCapture(m: RegexMatch; groupName: string; text: string): string
# func groupLastCapture(m: RegexMatch; groupName: string; text: string): string
# func groupsCount(m: RegexMatch): int
# func groupNames(m: RegexMatch): seq[string
# func findAndCaptureAll(s: string; pattern: Regex): seq[string]
# func splitIncl(s: string; sep: Regex): seq[string]
# func replace(s: string; pattern: Regex; by: string; limit = 0): string
# iterator group(m: RegexMatch; i: int): Slice[int]
# iterator group(m: RegexMatch; s: string): Slice[int]
# iterator findAll(s: string; pattern: Regex; start = 0): RegexMatch
# iterator findAllBounds(s: string; pattern: Regex; start = 0): Slice[int]
# iterator split(s: string; sep: Regex): string
