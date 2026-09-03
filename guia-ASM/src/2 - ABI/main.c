#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>

#include "../test-utils.h"
#include "ABI.h"

int main()
{
	/* Acá pueden realizar sus propias pruebas */
	uint32_t first = 0;
	uint32_t snd = -40;
	uint32_t thrd = -4;

	assert(alternate_sum_8(1, 1, 1, 1, 1, 1, 1, 1) == first);

	assert(alternate_sum_8(10, 20, 30, 40, 50, 60, 70, 80) == snd);

	assert(alternate_sum_8(1, 2, 3, 4, 5, 6, 7, 8) == thrd);

	return 0;
}
