#ifndef __NREGEX_H__
#define __NREGEX_H__

#include <stddef.h>

typedef struct nre_regex_t nre_regex_t;
typedef struct nre_regex_match_t nre_regex_match_t;

typedef struct nre_slice_t
{
  const unsigned int a;
  const unsigned int b;
} nre_slice_t;

#ifdef __cplusplus
extern "C" {
#endif

extern void nregex_init(void);

extern nre_regex_t* nre_regex_compile(const char* s);

extern int nre_regex_is_initialized(const nre_regex_t* re);

extern nre_regex_match_t* nre_regex_match_init(void);

extern int nre_match(const char* s, const nre_regex_t* pattern, nre_regex_match_t* m, unsigned int start);

extern int nre_is_match(const char* s, const nre_regex_t* pattern);

extern int nre_contains(const char* s, const nre_regex_t* pattern);

extern int nre_starts_with(const char* s, const nre_regex_t* pattern, unsigned int start);

extern int nre_ends_with(const char* s, const nre_regex_t* pattern);

extern int nre_find(const char* s, const nre_regex_t* pattern, nre_regex_match_t* m, unsigned int start);

extern int nre_regex_match_groups_count(const nre_regex_match_t* m);

extern char** nre_regex_match_group_names(const nre_regex_match_t* m, size_t* out_len);

extern char* nre_replace(const char* s, const nre_regex_t* pattern, const char* by, unsigned int limit);

extern char** nre_split_incl(const char* s, const nre_regex_t* sep, size_t* out_len);

extern char** nre_find_and_capture_all(const char* s, const nre_regex_t* pattern, size_t* out_len);

extern nre_regex_match_t** nre_find_all(const char* s, const nre_regex_t* pattern, unsigned int start, size_t* out_len);

extern char** nre_split(const char* s, const nre_regex_t* sep, size_t* out_len);

extern nre_slice_t* nre_find_all_bounds(const char* s, const nre_regex_t* pattern, unsigned int start, size_t* out_len);

extern char* nre_group_first_capture(const nre_regex_match_t* m, unsigned int i, const char* text);

extern char* nre_group_last_capture(const nre_regex_match_t* m, unsigned int i, const char* text);

extern char* nre_group_first_capture_by_group_name(const nre_regex_match_t* m, const char* group_name, const char* text);

extern char* nre_group_last_capture_by_group_name(const nre_regex_match_t* m, const char* group_name, const char* text);

extern char** nre_group(const nre_regex_match_t* m, unsigned int i, const char* text, size_t* out_len);

extern char** nre_group_by_group_name(const nre_regex_match_t* m, const char* group_name, const char* text, size_t* out_len);

extern nre_slice_t* nre_group_bounds(const nre_regex_match_t* m, unsigned int i, size_t* out_len);
      
extern nre_slice_t* nre_group_by_group_name_bounds(const nre_regex_match_t* m, const char* s, size_t* out_len);

extern void nre_regex_destroy(nre_regex_t* re);

extern void nre_regex_match_destroy(nre_regex_match_t* m);

#ifdef __cplusplus
}
#endif

#endif // __NREGEX_H__
