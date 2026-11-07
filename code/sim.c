#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>

typedef struct {
	int currVal;
	int futureVal;

} Register;

typedef struct {
	uint32_t instruction;
	int pc;

	int opcode;
	int rd;
	int rn;
	int rm;
	int immediate;

	int operand1;
	int operand2;
	int result;

	int valid;
} PipelineRegister;

typedef struct {
	PipelineRegister current;
	PipelineRegister future;
} PipelineState;

typedef struct {
	Register pc;
	Register registers[32];
	uint32_t memory[2048];

	PipelineState if_dr;
	PipelineState dr_ex1;
	PipelineState ex1_ex2;
	PipelineState ex2_mem;
	PipelineState mem_wb;

	int cycleCount;
} CPU;

void pulseClock(CPU *cpu);
int getRegisterValue(CPU *cpu, int reg);
void setRegisterValue(CPU *cpu, int reg, int val);
bool loadMemory(CPU *cpu, const char *fileName);

void instructionFetch(CPU *cpu);
void decodeInstruction(CPU *cpu);
void ex1(CPU *cpu);
void ex2(CPU *cpu);
void mem(CPU *cpu);
void writeBack(CPU *cpu, int result);

int main(int argc, char **argv) {
	CPU cpu = {0};

	if (argc < 2) {
		printf("No file found.\n");
		printf("Closing program\n");
		return 0;
	}

	if (!loadMemory(&cpu, argv[1])) {
		printf("Closing program\n");
		return 0;
	}

	return 0;
}

bool loadMemory(CPU *cpu, const char *fileName) {
	FILE *file = fopen(fileName, "r");

	if (file == NULL) {
		printf("Error opening file\n");
		return false;
	}

	unsigned int address;
	unsigned int value;

	while (fscanf(file, "%x %x", &address, &value) == 2) {
		if (address % 4 != 0 || address / 4 >= 2048) {
			fclose(file);
			return false;
		}

		cpu->memory[address / 4] = value;
	}

	if (!feof(file)) {
		fprintf(stderr, "Invalid memory file format\n");
		fclose(file);
		return false;
	}

	fclose(file);

	return true;
}

void pulseClock(CPU *cpu) {
	cpu->pc.currVal = cpu->pc.futureVal;

	for (int i = 0; i < 32; i++) {
		cpu->registers[i].currVal = cpu->registers[i].futureVal;
	}

	cpu->cycleCount += 1;
}

int getRegisterValue(CPU *cpu, int reg) {
	return cpu->registers[reg].currVal;
}

void setRegisterValue(CPU *cpu, int reg, int val) {
	cpu->registers[reg].futureVal = val;
}

void instructionFetch(CPU *cpu) {
}

void decodeInstruction(CPU *cpu) {
}

void ex1(CPU *cpu) {
}

void ex2(CPU *cpu) {
}

void mem(CPU *cpu) {
}

void writeBack(CPU *cpu, int result) {
}
