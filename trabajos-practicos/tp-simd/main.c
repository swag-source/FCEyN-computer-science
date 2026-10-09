#include "ej.h"
#include <math.h>
#include <stdint.h>
#include <stdio.h>

#include <raylib.h>

#define BUFFER_SIZE 512
#define SAMPLE_RATE 8192
#define WIDTH 640
#define HEIGHT 480

static
sincos_t sample_sincos(uint32_t frequency, uint32_t time) {
	float wavelength = SAMPLE_RATE / (float)frequency;
	return (sincos_t) {
		.sin = sinf(2*PI*time/wavelength),
		.cos = cosf(2*PI*time/wavelength),
	};
}

const uint32_t tone_to_low[] = {3, 0, 0, 0, 1, 1, 1, 2, 2, 2 };
const uint32_t tone_to_high[] = {1, 0, 1, 2, 0, 1, 2, 0, 1, 2 };

int main() {
	InitWindow(WIDTH, HEIGHT, "Orga DTMF");
	InitAudioDevice();

	SetAudioStreamBufferSizeDefault(BUFFER_SIZE);
	int16_t buffer[BUFFER_SIZE] = {};

	AudioStream stream = LoadAudioStream(SAMPLE_RATE, 16, 1);
	PlayAudioStream(stream);

	uint32_t time = 0;
	uint32_t tone = -1;

	sincos_t lows[4][BUFFER_SIZE];
	sincos_t highs[3][BUFFER_SIZE];

	size_t lowsz[4] = { 16*11, 16*2, 16*3, 16*6 };
	size_t highsz[3] = { 16*11, 16*23, 16*26 };

	int16_t ilow[4][BUFFER_SIZE];
	int16_t ihigh[3][BUFFER_SIZE];

	for (int i = 0; i < BUFFER_SIZE; i++) {
		lows[0][i] = sample_sincos(697, i);
		lows[1][i] = sample_sincos(770, i);
		lows[2][i] = sample_sincos(852, i);
		lows[3][i] = sample_sincos(941, i);

		highs[0][i] = sample_sincos(1209, i);
		highs[1][i] = sample_sincos(1336, i);
		highs[2][i] = sample_sincos(1477, i);
	}

	for (int n = 0; n < 4; n++) {
		for (int i = 0; i < lowsz[n]; i++) {
			ilow[n][i] = lows[n][i].sin * (1 << 13);
		}
	}

	for (int n = 0; n < 3; n++) {
		for (int i = 0; i < highsz[n]; i++) {
			ihigh[n][i] = highs[n][i].sin * (1 << 13);
		}
	}

	float df0 = 0, df1 = 0, df2 = 0, df3 = 0, dc0 = 0, dc1 = 0, dc2 = 0;
	char tecla = ' ';
	char detected_buf[4096];
	char deduped_buf[4096];
	size_t numbers[4] = {};
	size_t detected_buf_i = 0;
	while (!WindowShouldClose()) {
		if (IsKeyDown(KEY_KP_0) || IsKeyDown(KEY_ZERO))       tone = 0;
		else if (IsKeyDown(KEY_KP_1) || IsKeyDown(KEY_ONE))   tone = 1;
		else if (IsKeyDown(KEY_KP_2) || IsKeyDown(KEY_TWO))   tone = 2;
		else if (IsKeyDown(KEY_KP_3) || IsKeyDown(KEY_THREE)) tone = 3;
		else if (IsKeyDown(KEY_KP_4) || IsKeyDown(KEY_FOUR))  tone = 4;
		else if (IsKeyDown(KEY_KP_5) || IsKeyDown(KEY_FIVE))  tone = 5;
		else if (IsKeyDown(KEY_KP_6) || IsKeyDown(KEY_SIX))   tone = 6;
		else if (IsKeyDown(KEY_KP_7) || IsKeyDown(KEY_SEVEN)) tone = 7;
		else if (IsKeyDown(KEY_KP_8) || IsKeyDown(KEY_EIGHT)) tone = 8;
		else if (IsKeyDown(KEY_KP_9) || IsKeyDown(KEY_NINE))  tone = 9;
		else { tone = -1; time = 0; };

		if (IsKeyDown(KEY_SPACE)) {
			detected_buf_i = 0;
			numbers[0] = numbers[1] = numbers[2] = numbers[3] = 0;
			for (int i = 0; i < 4096; i++) {
				deduped_buf[i] = ' ';
			}
		}

		if (IsAudioStreamProcessed(stream)) {
			if (tone == -1) {
				for (int i = 0; i < BUFFER_SIZE; i++) {
					buffer[i] = 0;
				}
			} else {
				int l = tone_to_low[tone];
				int h = tone_to_high[tone];

				size_t low_start = BUFFER_SIZE * time % lowsz[l];
				size_t high_start = BUFFER_SIZE * time % highsz[h];
				ej1_sample(BUFFER_SIZE, buffer, lowsz[l], ilow[l], low_start, highsz[h], ihigh[h], high_start);
				time++;
			}
			UpdateAudioStream(stream, buffer, BUFFER_SIZE);

			/* Hago el step de detección */ {
				df0 = ej2_detect(BUFFER_SIZE, buffer, lows[0]);
				df1 = ej2_detect(BUFFER_SIZE, buffer, lows[1]);
				df2 = ej2_detect(BUFFER_SIZE, buffer, lows[2]);
				df3 = ej2_detect(BUFFER_SIZE, buffer, lows[3]);
				dc0 = ej2_detect(BUFFER_SIZE, buffer, highs[0]);
				dc1 = ej2_detect(BUFFER_SIZE, buffer, highs[1]);
				dc2 = ej2_detect(BUFFER_SIZE, buffer, highs[2]);

				int fila = -1;
				if (df0 > 2 && df0 >= df1 && df0 >= df2 && df0 >= df3) fila = 0;
				if (df1 > 2 && df1 >= df0 && df1 >= df2 && df1 >= df3) fila = 1;
				if (df2 > 2 && df2 >= df0 && df2 >= df1 && df2 >= df3) fila = 2;
				if (df3 > 2 && df3 >= df0 && df3 >= df1 && df3 >= df2) fila = 3;

				int columna = -1;
				if (dc0 > 2 && dc0 >= dc1 && dc0 >= dc2) columna = 0;
				if (dc1 > 2 && dc1 >= dc0 && dc1 >= dc2) columna = 1;
				if (dc2 > 2 && dc2 >= dc0 && dc2 >= dc1) columna = 2;

				static const char teclas[4][3] = {
					"123",
					"456",
					"789",
					"*0#"
				};
				tecla = fila == -1 && columna == -1 ? ' ' : teclas[fila][columna];

				for (int i = 0; i < 9; i++) {
					detected_buf[detected_buf_i++] = tecla;
					detected_buf_i %= 4096;
				}

				size_t padded_size = (detected_buf_i + 15) / 16 * 16;

				for (int i = 0; i < 4096; i++) deduped_buf[i] = ' ';
				ej3_remove_duplicates(padded_size, detected_buf, deduped_buf);
				ej4_get_numbers(4, deduped_buf, numbers);
			}
		}

		BeginDrawing();
			ClearBackground(RAYWHITE);
			DrawText(TextFormat("Playing tone: %d", tone), 10, 10, 20, GREEN);

			for (int i = 0; i < BUFFER_SIZE; i++) {
				int i0 = i;
				int i1 = (i + 1) % BUFFER_SIZE;
				Vector2 start = { i, 200 - (float)buffer[i0] / (1 << 14) * 100 };
				Vector2 end = { i + 1, 200 - (float)buffer[i1] / (1 << 14) * 100 };
				DrawLineV(start, end, BLACK);
			}

			DrawText(TextFormat("Detectado: %c", tecla), 10, 400, 20, RED);
			DrawText(TextFormat(" 697: %f", df0), 200, 300, 20, RED);
			DrawText(TextFormat(" 770: %f", df1), 200, 320, 20, RED);
			DrawText(TextFormat(" 852: %f", df2), 200, 340, 20, RED);
			DrawText(TextFormat(" 941: %f", df3), 200, 360, 20, RED);
			DrawText(TextFormat("1209: %f", dc0), 200, 400, 20, RED);
			DrawText(TextFormat("1336: %f", dc1), 200, 420, 20, RED);
			DrawText(TextFormat("1477: %f", dc2), 200, 440, 20, RED);

			DrawText(TextFormat("Dedupped: %s", deduped_buf), 10, 40, 20, BLACK);
			DrawText(TextFormat("%lu", numbers[0]),  10, 70, 20, BLACK);
			DrawText(TextFormat("%lu", numbers[1]), 300, 70, 20, BLACK);
			DrawText(TextFormat("%lu", numbers[2]),  10, 90, 20, BLACK);
			DrawText(TextFormat("%lu", numbers[3]), 300, 90, 20, BLACK);
		EndDrawing();
	}

	UnloadAudioStream(stream);
	CloseAudioDevice();

	CloseWindow();
	return 0;
}
