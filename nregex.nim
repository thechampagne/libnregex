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
# func contains(s: string; pattern: Regex): bool
# func find(s: string; pattern: Regex; m: var RegexMatch; start = 0): bool
# func splitIncl(s: string; sep: Regex): seq[string]
# func startsWith(s: string; pattern: Regex; start = 0): bool
# func endsWith(s: string; pattern: Regex): bool
# func replace(s: string; pattern: Regex; by: string; limit = 0): string
# iterator group(m: RegexMatch; i: int): Slice[int]
# iterator group(m: RegexMatch; s: string): Slice[int]
# iterator findAll(s: string; pattern: Regex; start = 0): RegexMatch
# iterator findAllBounds(s: string; pattern: Regex; start = 0): Slice[int]
# iterator split(s: string; sep: Regex): string
