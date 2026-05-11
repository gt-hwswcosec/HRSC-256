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

# 256-bit non-Mersenne PR
L256 = MPR(256, poly("x^256 + x^213 + x^133 + x^115 + x^48 + x^12 + 1"), poly("x^2"))

#256-bit CMPR
M107 = MPR(107, poly("x^107 + x^89 + x^84 + x^40 + x^29 + x^23 + 1"), poly("x^3 + x"))

M61 = MPR(61, poly("x^61 + x^44 + x^19 + x^15 + 1"), poly("x^4 + x^2"))

M31 = MPR(31, poly("x^31 + x^3 + x^2 + x^1 + 1"), poly("x^5 + 1"))

M19 = MPR(19, poly("x^19 + x^5 + x^2 + x^1 + 1"), poly("x^6"))

M17 = MPR(17, poly("x^17 + x^8 + x^4 + x^3 + 1"), poly("x^3"))

M13 = MPR(13, poly("x^13 + x^4 + x^3 + x^1 + 1"), poly("x^4"))

M5 = MPR(5, poly("x^5 + x^2 + 1"), poly("x^4 + x^3"))

M3 = MPR(3, poly("x^3 + x + 1"), poly("x^2 + x"))

C = CMPR([L256, M107, M61, M31, M19, M17, M13, M5, M3])

C.generateChaining(template=prob_ANF_template(max_and=4, max_xor=4, p = 0.3))

C.write_VHDL("large_hybrid_register.vhd")

F = FeedbackRegister([1]*512, C)

F.to_file("large_hybrid_register_stored.json")
