#!/usr/bin/env sage

### Import custom class for weierstrass elliptic functions
from weierstrass import *

### Load input
load('2d_input.sage')

### Initialize variables
var('z')
warning = False

components = 1
order = 2*numvars
secondorder = 0
lagnumvars = numvars
miwaconst = -2
squarearray = True
constraints = []
imposedpdes = [{},{},{}] #needs at least as many entries as components

if switch in multicompontent_list:
	components = multicompontent_list[switch]
if switch in order_list:
	order = order_list[switch]
if switch in secondorder_list:
	secondorder = secondorder_list[switch]
if switch in lagnumvars_list:
	lagnumvars = lagnumvars_list[switch]
if switch in miwa_list:
	miwaconst = miwa_list[switch]
if switch in squarearray_list:
	squarearray = squarearray_list[switch]
if switch in constraint_list:
	constraints = constraint_list[switch]
if switch in pde_list:
	imposedpdes = pde_list[switch]
	
### Open output files
filename = switch
if not(delta == 0):
	filename += '-delta'
filename += '-' + str(numvars)
if includeeven:
	filename += 'full'
plaindoc = open('datadump/' + filename + '-plain','w')
latexdoc = open('datadump/' + filename + '-tex','w')

### print to latex and plaintext files
### if all==True, print to console and pdf as well
w = walltime()
output = []

def latexadd(eqn,all=True):
	global output
	print ""
	print latex(eqn)
	print ""
	if all:
		output += ['\\tiny ' + latex(eqn)]
	if not(latexdoc.closed):
		latexdoc.write(latex(eqn) + '\n\n')
	if not(plaindoc.closed):
		plaindoc.write(str(eqn) + '\n\n')
		
def textadd(string,all=True):
	global output
	print "%.2f" % (walltime(w)) + "s: " + string
	if all:
		output += [string]
	if not(latexdoc.closed):
		latexdoc.write(string + '\n\n')
	if not(plaindoc.closed):
		plaindoc.write(string + '\n\n')

### Print mission statement
textadd('EQUATION ' + switch + ('' if delta==0 else ' with parameter ' + str(delta) ) )

### Load custom methods
load('2d_auxiliaries.sage')
load('2d_variational_calculus.sage')

### Compute limit of equations
load('2d_equation_limit.sage')

if not(onlyequation):
	### Compute limit of Lagrangians
	load('2d_lagrangian_limit.sage')
	### Eliminate alien derivatives
	load('2d_clean_lagrangian.sage')

### Finalize output
if warning:
    textadd('!!! WARNING(S) GENERATED !!!')
    
plaindoc.close()
latexdoc.close()

if viewpdf:
	view(output)

### If Lagrangians calculated and verified, write to file
if (not(onlyequation) and not(L==0) and (not(warning) and (elcheckdepth >= numvars))):
	lagfile = open('lagrangians/' + filename + '-plain','w')
	lagfile.write(str(pde))
	lagfile.write('\n')
	lagfile.write(str([[utriang(cleanlag)[i,j] for j in [0..lagnumvars-1]] for i in [0..lagnumvars-1]]))
	lagfile.close()
	lagfile = open('lagrangians/' + filename + '-tex','w')
	lagfile.write(latex(pde))
	lagfile.write('\n')
	lagfile.write(latex(utriang(cleanlag)))
	lagfile.close()
