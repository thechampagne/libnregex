import regex

type
  nre_regex_t = object
  nre_regex_match_t = object
  nre_slice_t = object
    a: cuint
    b: cuint

proc nre_regex_compile(s: cstring): ptr nre_regex_t {.exportc.} =
  let r = create Regex
  r[] = try:
          re($s)
        except CatchableError:
          return nil
  return cast[ptr nre_regex_t](r)

proc nre_regex_is_initialized(re: ptr nre_regex_t): cint {.exportc.} =
  let r = cast[ptr Regex](re)
  if isInitialized(r[]):
    return 1
  else:
    return 0

proc nre_regex_match_init(): ptr nre_regex_match_t {.exportc.} =
  let rm = create RegexMatch
  return cast[ptr nre_regex_match_t](rm)

proc nre_match(s: cstring, pattern: ptr nre_regex_t, m: ptr nre_regex_match_t, start: cuint): cint {.exportc.} =
  let r = cast[ptr Regex](pattern)
  var rm = cast[ptr RegexMatch](m)
  if match($s, r[], rm[], int(start)):
    return 1
  else:
    return 0

proc nre_is_match(s: cstring, pattern: ptr nre_regex_t): cint {.exportc.} =
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

proc nre_starts_with(s: cstring, pattern: ptr nre_regex_t, start: cuint): cint {.exportc.} =
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

proc nre_find(s: cstring, pattern: ptr nre_regex_t, m: ptr nre_regex_match_t, start: cuint): cint {.exportc.} =
  let r = cast[ptr Regex](pattern)
  var rm = cast[ptr RegexMatch](m)
  if find($s, r[], rm[], int(start)):
    return 1
  else:
    return 0

proc nre_regex_match_groups_count(m: ptr nre_regex_match_t): cint {.exportc.} =
  let rm = cast[ptr RegexMatch](m)
  return cint(groupsCount(rm[]))

proc nre_regex_match_group_names(m: ptr nre_regex_match_t, out_len: ptr csize_t): ptr ptr cchar {.exportc.} =
  let rm = cast[ptr RegexMatch](m)
  let names = groupNames(rm[])
  if names.len == 0:
    return nil
  var carray = cast[ptr ptr cchar](alloc((sizeof(ptr cchar)) * names.len))
  for i,v in names:
    var cstr = cast[ptr cchar](alloc((sizeof cchar) * v.len + 1))
    copyMem(cstr, cast[pointer](unsafeAddr v), v.len)
    cast[ptr UncheckedArray[cchar]](cstr)[v.len] = '\0'
    cast[ptr UncheckedArray[ptr cchar]](carray)[i] = cstr
  out_len[] = csize_t(names.len)
  return carray

proc nre_replace(s: cstring, pattern: ptr nre_regex_t, by: cstring, limit: cuint): ptr cchar {.exportc.} =
  let r = cast[ptr Regex](pattern)
  let replace = try:
                  replace($s, r[], $by, int(limit))
                except CatchableError:
                  return nil
  var cstr = cast[ptr cchar](alloc((sizeof cchar) * replace.len + 1))
  copyMem(cstr, cast[pointer](unsafeAddr replace), replace.len)
  cast[ptr UncheckedArray[cchar]](cstr)[replace.len] = '\0'
  return cstr

proc nre_split_incl(s: cstring, sep: ptr nre_regex_t, out_len: ptr csize_t): ptr ptr cchar {.exportc.} =
  let r = cast[ptr Regex](sep)
  let splits = splitIncl($s, r[])
  if splits.len == 0:
    return nil
  var carray = cast[ptr ptr cchar](alloc((sizeof(ptr cchar)) * splits.len))
  for i,v in splits:
    var cstr = cast[ptr cchar](alloc((sizeof cchar) * v.len + 1))
    copyMem(cstr, cast[pointer](unsafeAddr v), v.len)
    cast[ptr UncheckedArray[cchar]](cstr)[v.len] = '\0'
    cast[ptr UncheckedArray[ptr cchar]](carray)[i] = cstr
  out_len[] = csize_t(splits.len)
  return carray

proc nre_find_and_capture_all(s: cstring, pattern: ptr nre_regex_t, out_len: ptr csize_t): ptr ptr cchar {.exportc.} =
  let r = cast[ptr Regex](pattern)
  let capture = findAndCaptureAll($s, r[])
  if capture.len == 0:
    return nil
  var carray = cast[ptr ptr cchar](alloc((sizeof(ptr cchar)) * capture.len))
  for i,v in capture:
    var cstr = cast[ptr cchar](alloc((sizeof cchar) * v.len + 1))
    copyMem(cstr, cast[pointer](unsafeAddr v), v.len)
    cast[ptr UncheckedArray[cchar]](cstr)[v.len] = '\0'
    cast[ptr UncheckedArray[ptr cchar]](carray)[i] = cstr
  out_len[] = csize_t(capture.len)
  return carray

proc nre_find_all(s: cstring, pattern: ptr nre_regex_t, start: cuint, out_len: ptr csize_t): ptr ptr nre_regex_match_t {.exportc.} =
  let r = cast[ptr Regex](pattern)
  let all = findAll($s, r[], int(start))
  if all.len == 0:
    return nil
  var carray = cast[ptr ptr RegexMatch](alloc((sizeof(ptr RegexMatch)) * all.len))
  for i,v in all:
    var match = create RegexMatch
    match[] = v
    cast[ptr UncheckedArray[ptr RegexMatch]](carray)[i] = match
  out_len[] = csize_t(all.len)
  return cast[ptr ptr nre_regex_match_t](carray)

proc nre_split(s: cstring, sep: ptr nre_regex_t, out_len: ptr csize_t): ptr ptr cchar {.exportc.} =
  let r = cast[ptr Regex](sep)
  let splits = split($s, r[])
  if splits.len == 0:
    return nil
  var carray = cast[ptr ptr cchar](alloc((sizeof(ptr cchar)) * splits.len))
  for i,v in splits:
    var cstr = cast[ptr cchar](alloc((sizeof cchar) * v.len + 1))
    copyMem(cstr, cast[pointer](unsafeAddr v), v.len)
    cast[ptr UncheckedArray[cchar]](cstr)[v.len] = '\0'
    cast[ptr UncheckedArray[ptr cchar]](carray)[i] = cstr
  out_len[] = csize_t(splits.len)
  return carray

proc nre_find_all_bounds(s: cstring, pattern: ptr nre_regex_t, start: cuint, out_len: ptr csize_t): ptr nre_slice_t {.exportc.} =
  let r = cast[ptr Regex](pattern)
  let all = findAllBounds($s, r[], int(start))
  if all.len == 0:
    return nil
  var carray = cast[ptr nre_slice_t](alloc((sizeof(nre_slice_t)) * all.len))
  for i,v in all:
    var slice = nre_slice_t(a: cuint(v.a), b: cuint(v.b))
    cast[ptr UncheckedArray[nre_slice_t]](carray)[i] = slice
  out_len[] = csize_t(all.len)
  return carray

proc nre_group_first_capture(m: ptr nre_regex_match_t, i: cuint, text: cstring): ptr cchar {.exportc.} =
  let rm = cast[ptr RegexMatch](m)
  let cap = groupFirstCapture(rm[], int(i), $text)
  var cstr = cast[ptr cchar](alloc((sizeof cchar) * cap.len + 1))
  copyMem(cstr, cast[pointer](unsafeAddr cap), cap.len)
  cast[ptr UncheckedArray[cchar]](cstr)[cap.len] = '\0'
  return cstr

proc nre_group_last_capture(m: ptr nre_regex_match_t, i: cuint, text: cstring): ptr cchar {.exportc.} =
  let rm = cast[ptr RegexMatch](m)
  let cap = groupLastCapture(rm[], int(i), $text)
  var cstr = cast[ptr cchar](alloc((sizeof cchar) * cap.len + 1))
  copyMem(cstr, cast[pointer](unsafeAddr cap), cap.len)
  cast[ptr UncheckedArray[cchar]](cstr)[cap.len] = '\0'
  return cstr

proc nre_group_first_capture_by_group_name(m: ptr nre_regex_match_t, group_name: cstring, text: cstring): ptr cchar {.exportc.} =
  let rm = cast[ptr RegexMatch](m)
  let cap = try:
              groupFirstCapture(rm[], $group_name, $text)
            except CatchableError:
              return nil
  var cstr = cast[ptr cchar](alloc((sizeof cchar) * cap.len + 1))
  copyMem(cstr, cast[pointer](unsafeAddr cap), cap.len)
  cast[ptr UncheckedArray[cchar]](cstr)[cap.len] = '\0'
  return cstr

proc nre_group_last_capture_by_group_name(m: ptr nre_regex_match_t, group_name: cstring, text: cstring): ptr cchar {.exportc.} =
  let rm = cast[ptr RegexMatch](m)
  let cap = try:
              groupLastCapture(rm[], $group_name, $text)
            except CatchableError:
              return nil
  var cstr = cast[ptr cchar](alloc((sizeof cchar) * cap.len + 1))
  copyMem(cstr, cast[pointer](unsafeAddr cap), cap.len)
  cast[ptr UncheckedArray[cchar]](cstr)[cap.len] = '\0'
  return cstr

proc nre_group(m: ptr nre_regex_match_t, i: cuint, text: cstring, out_len: ptr csize_t): ptr ptr cchar {.exportc.} =
  let rm = cast[ptr RegexMatch](m)
  let cap = group(rm[], int(i), $text)
  if cap.len == 0:
    return nil
  var carray = cast[ptr ptr cchar](alloc((sizeof(ptr cchar)) * cap.len))
  for i,v in cap:
    var cstr = cast[ptr cchar](alloc((sizeof cchar) * v.len + 1))
    copyMem(cstr, cast[pointer](unsafeAddr v), v.len)
    cast[ptr UncheckedArray[cchar]](cstr)[v.len] = '\0'
    cast[ptr UncheckedArray[ptr cchar]](carray)[i] = cstr
  out_len[] = csize_t(cap.len)
  return carray

proc nre_group_by_group_name(m: ptr nre_regex_match_t, group_name: cstring, text: cstring, out_len: ptr csize_t): ptr ptr cchar {.exportc.} =
  let rm = cast[ptr RegexMatch](m)
  let cap = try:
              group(rm[], $group_name, $text)
            except CatchableError:
              return nil
  if cap.len == 0:
    return nil
  var carray = cast[ptr ptr cchar](alloc((sizeof(ptr cchar)) * cap.len))
  for i,v in cap:
    var cstr = cast[ptr cchar](alloc((sizeof cchar) * v.len + 1))
    copyMem(cstr, cast[pointer](unsafeAddr v), v.len)
    cast[ptr UncheckedArray[cchar]](cstr)[v.len] = '\0'
    cast[ptr UncheckedArray[ptr cchar]](carray)[i] = cstr
  out_len[] = csize_t(cap.len)
  return carray

proc nre_group_bounds(m: ptr nre_regex_match_t, i: cuint, out_len: ptr csize_t): ptr nre_slice_t {.exportc.} =
  let rm = cast[ptr RegexMatch](m)
  let all = try:
              group(rm[], int(i))
            except CatchableError:
              return nil
  if all.len == 0:
    return nil
  var carray = cast[ptr nre_slice_t](alloc((sizeof(nre_slice_t)) * all.len))
  for i,v in all:
    var slice = nre_slice_t(a: cuint(v.a), b: cuint(v.b))
    cast[ptr UncheckedArray[nre_slice_t]](carray)[i] = slice
  out_len[] = csize_t(all.len)
  return carray

proc nre_group_by_group_name_bounds(m: ptr nre_regex_match_t, s: cstring, out_len: ptr csize_t): ptr nre_slice_t {.exportc.} =
  let rm = cast[ptr RegexMatch](m)
  let all = group(rm[], $s)
  if all.len == 0:
    return nil
  var carray = cast[ptr nre_slice_t](alloc((sizeof(nre_slice_t)) * all.len))
  for i,v in all:
    var slice = nre_slice_t(a: cuint(v.a), b: cuint(v.b))
    cast[ptr UncheckedArray[nre_slice_t]](carray)[i] = slice
  out_len[] = csize_t(all.len)
  return carray

proc nre_regex_destroy(re: ptr nre_regex_t) {.exportc.} =
  if re != nil:
    dealloc cast[ptr Regex](re)

proc nre_regex_match_destroy(m: ptr nre_regex_match_t) {.exportc.} =
  if m != nil:
    dealloc cast[ptr RegexMatch](m)
