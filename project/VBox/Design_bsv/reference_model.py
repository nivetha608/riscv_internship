class VectorALU:
    def __init__(self, num_regs=32, vlen=8, mem_size=16):
        self.vregs = [[0]*vlen for _ in range(num_regs)]  # Vector registers v0 to v31
        self.memory = [[0]*vlen for _ in range(mem_size)]  # Simple vector memory

    def write_reg(self, idx, vec):
        assert 0 <= idx < len(self.vregs)
        assert len(vec) == len(self.vregs[0])
        self.vregs[idx] = vec.copy()

    def read_reg(self, idx):
        assert 0 <= idx < len(self.vregs)
        return self.vregs[idx].copy()

    def vadd_vv(self, vd, vs1, vs2):
        self.vregs[vd] = [a + b for a, b in zip(self.vregs[vs1], self.vregs[vs2])]

    def vsub_vv(self, vd, vs1, vs2):
        self.vregs[vd] = [a - b for a, b in zip(self.vregs[vs1], self.vregs[vs2])]

    def vstore(self, vs1, mem_idx):
        assert 0 <= mem_idx < len(self.memory)
        self.memory[mem_idx] = self.vregs[vs1].copy()

    def vload(self, vd, mem_idx):
        assert 0 <= mem_idx < len(self.memory)
        self.vregs[vd] = self.memory[mem_idx].copy()

# Example usage:
if __name__ == "__main__":
    alu = VectorALU()

    # Initialize v1 and v2
    alu.write_reg(1, [10, 20, 30, 40, 0, -10, 0, 0])
    alu.write_reg(2, [1, 2, 3, 4, 0, -30, 0, -20])

    # ADD v1 + v2 -> v3
    alu.vadd_vv(3, 1, 2)
    print("v3 (ADD):", alu.read_reg(3))

    # SUB v1 - v2 -> v4
    alu.vsub_vv(4, 1, 2)
    print("v4 (SUB):", alu.read_reg(4))

    # STORE v4 to memory[0]
    alu.vstore(4, 0)

    # LOAD memory[0] -> v10
    alu.vload(10, 0)
    print("v10 (LOAD):", alu.read_reg(10))
