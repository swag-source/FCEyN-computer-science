#include <assert.h>
#include <math.h>
#include <stdint.h>

#include "test-utils.h"
#include "ej.h"

#define PI 3.14159265358979323846f

#define BUFFER_SIZE 512
#define SAMPLE_RATE 8192


#define MAX_TO_FREE 1024
static size_t to_free_curr = 0;
static void* to_free[MAX_TO_FREE];
void* testbuf(size_t size) {
	assert(to_free_curr < MAX_TO_FREE);
	return to_free[to_free_curr++] = malloc(size);
}
#define NEW(type) testbuf(sizeof(type))

char* textbuf(size_t size, char* fill) {
	char* res = testbuf(size);
	char* cur = res;
	while(*fill) *cur++ = *fill++;
	return res;
}

sincos_t sample_sincos(uint32_t frequency, uint32_t time) {
	float wavelength = SAMPLE_RATE / (float)frequency;
	return (sincos_t) {
		.sin = sinf(2*PI*time/wavelength),
		.cos = cosf(2*PI*time/wavelength),
	};
}

#define SIGNAL(name, size, expr)           \
  size_t name##_sz = size;                 \
  int16_t* name = NEW(int16_t[name##_sz]); \
  for (size_t i = 0; i < name##_sz; i++) { \
    name[i] = expr;                        \
  }

#define SINCOS(name, size, freq)             \
  size_t name##_sz = size;                   \
  sincos_t* name = NEW(sincos_t[name##_sz]); \
  for (size_t i = 0; i < name##_sz; i++) {   \
    name[i] = sample_sincos(freq, i);        \
  }

#define ASSERT_SIGNAL(out, contents)               \
  for (size_t i = 0; i < out##_sz; i++) {          \
    TEST_ASSERT_EQUALS(int16_t, contents, out[i]); \
  }

TEST(ej1_test_empty_buffer) {
	SIGNAL(freq_a, 128, 0);
	SIGNAL(freq_b, 128, 0);

	ej1_sample(0, NULL, freq_a_sz, freq_a,  0, freq_b_sz, freq_b,  0);
	ej1_sample(0, NULL, freq_a_sz, freq_a, 16, freq_b_sz, freq_b, 16);
}

TEST(ej1_adding_a_signal_to_itself_is_a_no_op) {
	SIGNAL(freq, 128, i*i);
	SIGNAL(out,  128, 0);

	ej1_sample(out_sz, out, freq_sz, freq, 0, freq_sz, freq, 0);
	ASSERT_SIGNAL(out, freq[i]);
}

TEST(ej1_added_signals_repeat) {
	SIGNAL(freq_a, 32,  i);
	SIGNAL(freq_b, 48, -i*i);
	SIGNAL(out,    128, 0);

	ej1_sample(out_sz, out, freq_a_sz, freq_a, 0, freq_b_sz, freq_b, 0);
	ASSERT_SIGNAL(out, (freq_a[i % freq_a_sz] + freq_b[i % freq_b_sz]) / 2);
}

TEST(ej1_can_offset_added_signal) {
	SIGNAL(freq, 96,  i);
	SIGNAL(out, 128, 0);

	ej1_sample(out_sz, out, freq_sz, freq, 16, freq_sz, freq, 32);
	ASSERT_SIGNAL(out, (((i + 16) % freq_sz) + ((i + 32) % freq_sz)) / 2);
}

TEST(ej1_signal_is_truncated_if_output_too_small) {
	SIGNAL(freq, 1024, (i % 128) + i);
	SIGNAL(out, 128, 0);

	for (size_t chunk_start = 0; chunk_start <  freq_sz; chunk_start += out_sz) {
		ej1_sample(out_sz, out, freq_sz, freq, chunk_start, freq_sz, freq, chunk_start);
		ASSERT_SIGNAL(out, freq[chunk_start + i]);
	}
}

TEST(ej2_detects_a_single_sine) {
	SINCOS(f440, 1024, 440);
	SIGNAL(s, 1024, f440[i].sin * 128);
	float res = ej2_detect(s_sz, s, f440);
	TEST_ASSERT(127 <= res && res <= 128);
}

TEST(ej2_does_not_detect_a_sine_in_silence) {
	SINCOS(f440, 1024, 440);
	SIGNAL(s, 1024, 0);
	float res = ej2_detect(s_sz, s, f440);
	TEST_ASSERT(0 <= res && res < 1);
}

TEST(ej2_detects_both_sines_of_a_dual_tone) {
	SINCOS(f440, 1024, 440);
	SINCOS(f937, 1024, 937);
	SIGNAL(s, 1024, f440[i].sin * 128 + f937[i].sin * 64);
	float res = ej2_detect(s_sz, s, f440);
	TEST_ASSERT(127 <= res && res <= 128);
	res = ej2_detect(s_sz, s, f937);
	TEST_ASSERT(63 <= res && res <= 64);
}

TEST(ej2_does_not_detect_sines_that_are_not_there) {
	SINCOS(f440, 1024, 440);
	SINCOS(f880, 1024, 880);
	SIGNAL(s, 1024, f880[i].sin * 128);
	float res = ej2_detect(s_sz, s, f440);
	TEST_ASSERT(0 <= res && res < 1);
}

TEST(ej2_works_with_cosines) {
	SINCOS(f440, 1024, 440);
	SIGNAL(s, 1024, f440[i].cos * 128);
	float res = ej2_detect(s_sz, s, f440);
	TEST_ASSERT(127 <= res && res <= 128);
}

TEST(ej3_can_collapse_everything_to_a_single_letter) {
	char* in = textbuf(32, "00000000000000000000000000000000");
	char* out = textbuf(16, "$$$$$$$$$$$$$$$$");

	ej3_remove_duplicates(32, in, out);

	TEST_ASSERT_EQUALS(char, '0', out[0]);
	for (int i = 1; i < 16; i++) {
		TEST_ASSERT_EQUALS(char, '$', out[i]);
	}
}

TEST(ej3_ignores_whitespace_blocks) {
	char* in = textbuf(96, "00000000000000000000000000000000"
	                       "                                "
	                       "00000000000000001111111111111111");
	char* out= textbuf(16, "$$$$$$$$$$$$$$$$");

	ej3_remove_duplicates(96, in, out);

	TEST_ASSERT_EQUALS(char, '0', out[0]);
	TEST_ASSERT_EQUALS(char, '0', out[1]);
	TEST_ASSERT_EQUALS(char, '1', out[2]);
	for (int i = 3; i < 16; i++) {
		TEST_ASSERT_EQUALS(char, '$', out[i]);
	}
}

TEST(ej3_ignores_mixed_blocks) {
	char* in = textbuf(96, "00000000000000000000000000000000"
	                       "11113333388888888444444444442222"
	                       "11111111111111110000000000000000");
	char* out = textbuf(16, "$$$$$$$$$$$$$$$$");

	ej3_remove_duplicates(96, in, out);

	TEST_ASSERT_EQUALS(char, '0', out[0]);
	TEST_ASSERT_EQUALS(char, '1', out[1]);
	TEST_ASSERT_EQUALS(char, '0', out[2]);
	for (int i = 3; i < 16; i++) {
		TEST_ASSERT_EQUALS(char, '$', out[i]);
	}
}

TEST(ej3_stress_test) {
	char* in = textbuf(288, "       0000000000000000000000000"
	                        "11113333388888888444444444442222"
	                        "22222222222222222222000000000000"
	                        "00000000000000000000     9999999"
	                        "9999999999999999999           66"
	                        "666666666666666666     333333333"
	                        "33333333333333333333333333333333"
	                        "33333333333333333333333333333333"
	                        "3333333333333333333333333       ");
	char* out = textbuf(16, "$$$$$$$$$$$$$$$$");

	ej3_remove_duplicates(288, in, out);

	TEST_ASSERT_EQUALS(char, '0', out[0]);
	TEST_ASSERT_EQUALS(char, '2', out[1]);
	TEST_ASSERT_EQUALS(char, '0', out[2]);
	TEST_ASSERT_EQUALS(char, '9', out[3]);
	TEST_ASSERT_EQUALS(char, '6', out[4]);
	TEST_ASSERT_EQUALS(char, '3', out[5]);
	for (int i = 6; i < 16; i++) {
		TEST_ASSERT_EQUALS(char, '$', out[i]);
	}
}

TEST(ej4_decodes_single_input) {
	char* in = textbuf(16, "9876543210");
	size_t* out = NEW(size_t[1]);
	ej4_get_numbers(1, in, out);
	TEST_ASSERT_EQUALS(size_t, 9876543210L, out[0]);
}

TEST(ej4_decodes_multiple_inputs) {
	char* in = textbuf(66, "9876543210"
	                       "    676767"
	                       "      4602"
	                       "         0"
	                       "  13371337"
	                       "  00300300");
	size_t* out = NEW(size_t[6]);
	ej4_get_numbers(6, in, out);
	TEST_ASSERT_EQUALS(size_t, 9876543210L, out[0]);
	TEST_ASSERT_EQUALS(size_t,     676767L, out[1]);
	TEST_ASSERT_EQUALS(size_t,       4602L, out[2]);
	TEST_ASSERT_EQUALS(size_t,          0L, out[3]);
	TEST_ASSERT_EQUALS(size_t,   13371337L, out[4]);
	TEST_ASSERT_EQUALS(size_t,     300300L, out[5]);
}

int main() {
	if (ej_1_hecho) {
		ej1_test_empty_buffer();
		ej1_adding_a_signal_to_itself_is_a_no_op();
		ej1_added_signals_repeat();
		ej1_can_offset_added_signal();
		ej1_signal_is_truncated_if_output_too_small();
	} else {
		puts("- " ANSI_COLOR_YELLOW "Ejercicio 1 no implementado" ANSI_COLOR_RESET);
	}

	if (ej_2_hecho) {
		ej2_detects_a_single_sine();
		ej2_does_not_detect_a_sine_in_silence();
		ej2_detects_both_sines_of_a_dual_tone();
		ej2_does_not_detect_sines_that_are_not_there();
		ej2_works_with_cosines();
	} else {
		puts("- " ANSI_COLOR_YELLOW "Ejercicio 2 no implementado" ANSI_COLOR_RESET);
	}

	if (ej_3_hecho) {
		ej3_can_collapse_everything_to_a_single_letter();
		ej3_ignores_whitespace_blocks();
		ej3_ignores_mixed_blocks();
		ej3_stress_test();
	} else {
		puts("- " ANSI_COLOR_YELLOW "Ejercicio 3 no implementado" ANSI_COLOR_RESET);
	}

	if (ej_4_hecho) {
		ej4_decodes_single_input();
		ej4_decodes_multiple_inputs();
	} else {
		puts("- " ANSI_COLOR_YELLOW "Ejercicio 4 no implementado" ANSI_COLOR_RESET);
	}

	for (size_t i = 0; i < to_free_curr; i++) {
		free(to_free[i]);
	}

	tests_end("TP SIMD");
	return 0;
}
