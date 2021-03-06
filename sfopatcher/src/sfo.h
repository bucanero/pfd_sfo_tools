#ifndef _SFO_H_
#define _SFO_H_

#include "types.h"

#ifdef __cplusplus
extern "C" {
#endif

#define SFO_PATCH_FLAG_REMOVE_COPY_PROTECTION (1 << 0)

typedef struct sfo_context_s sfo_context_t;

typedef struct sfo_key_pair_s {
	const char *name;
	int flag;
} sfo_key_pair_t;

sfo_context_t * sfo_alloc(void);
void sfo_free(sfo_context_t *context);

int sfo_read(sfo_context_t *context, const char *file_path);
int sfo_write(sfo_context_t *context, const char *file_path);

void sfo_grab(sfo_context_t *inout, sfo_context_t *tpl, int num_keys, const sfo_key_pair_t *keys);
void sfo_patch(sfo_context_t *inout, unsigned int flags);

#ifdef __cplusplus
}
#endif

#endif /* !_SFO_H_ */
