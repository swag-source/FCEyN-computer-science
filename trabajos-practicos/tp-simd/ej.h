#pragma once
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

typedef struct sincos {
	float sin;
	float cos;
} sincos_t;

extern const bool ej_1_hecho;
extern const bool ej_2_hecho;
extern const bool ej_3_hecho;
extern const bool ej_4_hecho;

void ej1_sample(size_t buf_len, int16_t buf[buf_len],
                size_t freq_a_len, int16_t freq_a[freq_a_len], size_t a_start,
                size_t freq_b_len, int16_t freq_b[freq_b_len], size_t b_start);

float ej2_detect(size_t size, int16_t signal[size], sincos_t freq[size]);

void ej3_remove_duplicates(size_t size, char detected[size], char output[]);

void ej4_get_numbers(size_t size, char numbers[10 * (size - 1) + 16], size_t output[size]);
