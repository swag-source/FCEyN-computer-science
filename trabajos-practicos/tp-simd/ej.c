#include <math.h>
#include <stdbool.h>

#include "ej.h"

const bool ej_1_hecho = true;
const bool ej_2_hecho = true;
const bool ej_3_hecho = true;
const bool ej_4_hecho = true;

void ej1_sample(size_t buf_len, int16_t buf[buf_len],
				size_t freq_a_len, int16_t freq_a[freq_a_len], size_t a_start,
				size_t freq_b_len, int16_t freq_b[freq_b_len], size_t b_start)
{
	for (size_t i = 0; i < buf_len; i++)
	{
		size_t index_a = (i + a_start) % freq_a_len;
		size_t index_b = (i + b_start) % freq_b_len;
		int16_t sample_a = freq_a[index_a];
		int16_t sample_b = freq_b[index_b];
		buf[i] = (sample_a + sample_b) / 2;
	}
}

float ej2_detect(size_t size, int16_t signal[size], sincos_t freq[size])
{
	float re = 0;
	float im = 0;
	for (size_t i = 0; i < size; i++)
	{
		re += signal[i] * freq[i].cos;
		im += signal[i] * freq[i].sin;
	}
	return 2 * sqrtf(re * re + im * im) / size;
}

void ej3_remove_duplicates(size_t size, char detected[size], char output[])
{
	int outi = 0;
	char c = ' ';
	for (int i = 0; i < size; i += 16)
	{
		bool all_the_same = (detected[i + 0] == detected[i + 1]) && (detected[i + 1] == detected[i + 2]) && (detected[i + 2] == detected[i + 3]) && (detected[i + 3] == detected[i + 4]) && (detected[i + 4] == detected[i + 5]) && (detected[i + 5] == detected[i + 6]) && (detected[i + 6] == detected[i + 7]) && (detected[i + 7] == detected[i + 8]) && (detected[i + 8] == detected[i + 9]) && (detected[i + 9] == detected[i + 10]) && (detected[i + 10] == detected[i + 11]) && (detected[i + 11] == detected[i + 12]) && (detected[i + 12] == detected[i + 13]) && (detected[i + 13] == detected[i + 14]) && (detected[i + 14] == detected[i + 15]);
		if (!all_the_same)
			continue;
		if (detected[i] == c)
			continue;

		c = detected[i];

		if (c == ' ')
			continue;

		output[outi] = detected[i];
		outi++;
	}
}

void ej4_get_numbers(size_t size, char numbers[10 * (size - 1) + 16], size_t output[size])
{
	size_t outi = 0;
	for (int i = 0; i < 10 * size; i += 10)
	{
		// Los números vienen en bloques de 10 caracteres
		uint8_t digitos[] = {
			numbers[i + 0] == ' ' ? 0 : numbers[i + 0] - '0',
			numbers[i + 1] == ' ' ? 0 : numbers[i + 1] - '0',
			numbers[i + 2] == ' ' ? 0 : numbers[i + 2] - '0',
			numbers[i + 3] == ' ' ? 0 : numbers[i + 3] - '0',
			numbers[i + 4] == ' ' ? 0 : numbers[i + 4] - '0',
			numbers[i + 5] == ' ' ? 0 : numbers[i + 5] - '0',
			numbers[i + 6] == ' ' ? 0 : numbers[i + 6] - '0',
			numbers[i + 7] == ' ' ? 0 : numbers[i + 7] - '0',
			numbers[i + 8] == ' ' ? 0 : numbers[i + 8] - '0',
			numbers[i + 9] == ' ' ? 0 : numbers[i + 9] - '0',
		};
		uint64_t valor = digitos[0] * 1000000000L + digitos[1] * 100000000L + digitos[2] * 10000000L + digitos[3] * 1000000L + digitos[4] * 100000L + digitos[5] * 10000L + digitos[6] * 1000L + digitos[7] * 100L + digitos[8] * 10L + digitos[9] * 1L;
		output[outi++] = valor;
	}
}
