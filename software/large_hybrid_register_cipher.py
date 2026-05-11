# Basic constructs:
from ProductRegisters.FeedbackRegister import FeedbackRegister
from ProductRegisters.FeedbackFunctions import *

# Boolean logic and chaining templates
from ProductRegisters.BooleanLogic import *
from ProductRegisters.BooleanLogic.ChainingGeneration.Templates import *
import ProductRegisters.BooleanLogic.ChainingGeneration.TemplateBuilding

# Berlekamp-Massey and variants
from ProductRegisters.Tools.RegisterSynthesis.lfsrSynthesis import *
from ProductRegisters.Tools.RegisterSynthesis.fcsrSynthesis import *
from ProductRegisters.Tools.RegisterSynthesis.nlfsrSynthesis import *

# Tools and other extraneous files
import ProductRegisters.Tools.ResolventSolving as ResolventSolving
from ProductRegisters.Tools.RootCounting.MonomialProfile import *

# Cryptanalysis:
from ProductRegisters.Cryptanalysis.Attacks.cube_attacks import *
from ProductRegisters.Cryptanalysis.utility import *

F = FeedbackRegister.from_file('large_hybrid_register_stored.json')
F.fn.write_VHDL("large_hybrid_register.vhd")
F.fn.compile()

def hybrid_register_cipher(key, iv, keystream_length):
    initrounds = 128
    initstate_iv = str2list(iv)
    initstate = str2list(key)
    if (len(key) != 256):
        print("Key must be 256 bits.")
        quit()
    if (len(iv) != 96):
        print("IV must be 96 bits.")
        quit()

    if (any(x != '0' and x != '1' for x in key) | any(x != '0' and x != '1' for x in iv)):
        print("Key and IV must be in binary format (base 2).")
        quit()
    
    F.seed([1]*160 + initstate_iv + initstate)

    F.reset()
    keystream = ""

    for _ in range(initrounds):
        F.clock_compiled()

    for state in F.run_compiled(keystream_length):
        keystream += str(state[0] ^ state[3] ^ state[7] ^ state[15])
    return keystream
    
filein = open('./ivs.txt', 'r')
lines = filein.readlines()
fileout = open('./keystreams.txt', 'w')
fileout_const = open('./fixed_key.txt', 'w')
key = generate_random_binary(256)
fileout_const.write(key)
j = 1

for line in lines:
    iv = line.strip()
    keystream = hybrid_register_cipher(key, iv, 256)
    fileout.write(keystream + '\n')
    print("Keystream #" + str(j) + " generated.")
    j += 1

filein.close()
fileout.close()
fileout_const.close()
