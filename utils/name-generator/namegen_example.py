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

Example usage and simple demonstration.
"""

import os
from namegen import NameGen


#get all available language files
files = os.listdir('./Languages')


exit = False
while not exit:
	print 'Select a language file: (any other input to quit)\n'

	#present all available files as options
	for (id, file) in enumerate(files):
		print id, ': ', file
	
	#interpret option number, if anything goes wrong quit
	try:
		filename = files[int(raw_input())]
	except ValueError or IndexError:
		break
	
	
	#load generator data from language file
	generator = NameGen('Languages/' + filename)
	
	
	#generate a few words
	for i in range(20):
		print generator.gen_word()
	
	
	#pause (wait for some input)
	print '\nPress Enter to continue.'
	try:
		raw_input()
	except EOFError:
		pass

