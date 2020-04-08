"""
Copyright 2010 Joao Henriques <jotaf (no spam) at hotmail dot com>.

This file is part of name-gen.

name-gen is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

name-gen is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with name-gen.  If not, see
<http://www.gnu.org/licenses/>.
"""

"""
name-gen: Free python name generator module that analyzes sample text and produces
	similar words.

Training process for learning words from a sample text.

Provided 'Samples/[filename].txt', output will be 'Languages/[filename].txt'.
Default is 3 letters per syllable, but 2 letters can be selected with the option
'--small'. In that case, output will be 'Languages/[filename]2.txt'.

Generally, syllables of 3 letters encode more complex patterns (ie, yield better
results), but may take some time to learn big samples (for example, 'lusiadas' has
300KB of text so takes a few minutes).
"""

import itertools
import os
import locale
import optparse
import namegen

def main():
	#parse command line options
	parser = optparse.OptionParser(usage='namegen_train.py filename [options]\n\n'
		'Typical usage has only the filename.\nType namegen_train.py -h for more options.')
	parser.add_option('-f', default=0.2, help='Fraction of acceptable syllables of 2 letters (default 0.2).')
	parser.add_option('-F', default=0.05, help='Fraction of acceptable syllables of 3 letters (default 0.05).')
	parser.add_option('--small', default=False, action='store_true', help='Only use syllables of 2 letters (faster).')
	(options, args) = parser.parse_args()
	
	try:
		options.f = float(options.f)
		options.F = float(options.F)
	except ValueError:
		parser.error('Fractions must be decimal numbers between 0 and 1.')
	
	if options.f < 0 or options.f > 1 or options.F < 0 or options.F > 1:
		parser.error('Fractions must be decimal numbers between 0 and 1.')
	
	if len(args) != 1:
		parser.error('Must supply the name of a language file, without the\n'
		'extension (.txt), from the Samples folder. Check the Samples folder for a list.')
	
	filename = args[0]
	
	
	print '\n>>> name-gen 1.0 training procedure for "' + filename + '"\n'
	
	tic()
	try:  #get sample text and convert special characters if needed
		sample = namegen._load_sample('Samples/' + filename + '.txt')
		
	except IOError:
		parser.error('Language file \'Samples/' + filename + '.txt\' doesn\' exist.')
	toc('Load sample')


	tic()
	#get list of syllables of 2 letters
	syllables = get_best_syllables(2, options.f, sample)

	#optionally, do the same with 3 letters syllables (slower)
	if not options.small:
		syllables.extend(get_best_syllables(3, options.F, sample))
	toc('Scan syllables')

	tic()
	(combinations, starts, ends) = count_combinations(syllables, sample)
	toc('Scan combinations')


	tic()
	#save the results
	if not options.small: language_file = 'Languages/' + filename + '.txt'
	else: language_file = 'Languages/' + filename + '2.txt'

	save_language(language_file, syllables, starts, ends, combinations)
	toc('Save output')

	tic()
	generator = namegen.NameGen(language_file)
	toc('Re-load language (for testing purposes)')
	
	tic()
	#generate a few words
	for i in range(20):
		print generator.gen_word()
	toc('Generate 20 words')


	#pause (wait for some input)
	try:
		print 'Done.'
		raw_input()
	except EOFError:
		pass

def get_count(count_tuple):
	return count_tuple[1]

def get_best_syllables(num_letters, fraction, sample):
	alphabet = [chr(i) for i in range(ord('a'), ord('z') + 1)]
	
	#get all possible syllables using this number of letters, then count
	#them in the sample. output is list of tuples (syllable, count).
	counts = [(''.join(letters), sample.count(''.join(letters)))
		for letters in itertools.product(alphabet, repeat = num_letters)]
	
	#output to comma-separated-values file (view in Excel), useful to figure out fraction parameters.
	#print counts, len(counts)
	#with open('counts.csv','w') as f:
	#	f.write(''.join([str(count_tuple[1]) + '\n' for count_tuple in counts]))
	
	#get only the syllables with the most counts, up to the fraction specified
	counts.sort(key = get_count)
	n = int(fraction * len(counts))
	counts = counts[-n:]
	
	#get syllables from the tuples by "unzipping"
	syllables = list(zip(*counts)[0])
	return syllables

def count_combinations(syllables, sample):
	combinations = []
	for prefix in syllables:
		combinations.append(count_with_prefix(syllables, prefix, sample))
	
	starts = count_with_prefix(syllables, ' ', sample)
	ends = count_with_postfix(syllables, ' ', sample)
	
	return (combinations, starts, ends)

def count_with_prefix(syllables, prefix, sample):
	combinations = []
	total = 0
	for (index, syl) in enumerate(syllables):
		count = sample.count(prefix + syl)
		if count != 0:
			total += count
			combinations.append([index, total])
	return combinations

def count_with_postfix(syllables, postfix, sample):
	combinations = []
	total = 0
	for (index, syl) in enumerate(syllables):
		count = sample.count(syl + postfix)
		if count != 0:
			total += count
			combinations.append([index, total])
	return combinations

def save_language(language_file, syllables, starts, ends, combinations):
	with open(language_file, 'w') as f:
		(starts_ids, starts_counts) = zip(*starts)  #unzip list of tuples into 2 lists
		(ends_ids, ends_counts) = zip(*ends)
		
		lines = [
			','.join(syllables) + '\n',
			','.join([str(n) for n in starts_ids]) + '\n',
			','.join([str(n) for n in starts_counts]) + '\n',
			','.join([str(n) for n in ends_ids]) + '\n',
			','.join([str(n) for n in ends_counts]) + '\n',
		]
		
		for line in combinations:
			if len(line) == 0:  #special case, empty
				lines.append('\n');
				lines.append('\n');
			else:
				(line_ids, line_counts) = zip(*line)
				lines.append(','.join([str(n) for n in line_ids]) + '\n')
				lines.append(','.join([str(n) for n in line_counts]) + '\n')
		f.writelines(lines)

def tic():  #profiling functions
	global tictoc
	tictoc = os.times()[0]
	
def toc(msg = 'Elapsed time'):
	print msg + ': ' + str(os.times()[0] - tictoc) + 's'

if __name__ == '__main__': main()
