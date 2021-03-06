## ---------------------------------------------------------------------
##
## Copyright (C) 2017 by the gscf authors
##
## This file is part of gscf.
##
## gscf is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published
## by the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## gscf is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with gscf. If not, see <http://www.gnu.org/licenses/>.
##
## ---------------------------------------------------------------------

#
# The sources for this example executable
#
# Compile and link:
add_executable(hartree_fock
	loewdin_guess.cc
	main.cc
)

set_target_properties(
	hartree_fock
	PROPERTIES
	LINK_FLAGS "${CMAKE_EXE_LINKER_FLAGS_${EXAMPLES_BUILD_TYPE}}" #${CMAKE_EXE_LINKER_FLAGS} are added
	LINKER_LANGUAGE "CXX"
	COMPILE_FLAGS "${CMAKE_CXX_FLAGS_${EXAMPLES_BUILD_TYPE}}" #${CMAKE_CXX_FLAGS} are added automaticaly
	COMPILE_DEFINITIONS "${EXAMPLES_BUILD_TYPE}"
)

# link it with the appropriate gscf and gscfmock library target
target_link_libraries(hartree_fock
	${gscf_${EXAMPLES_BUILD_TYPE}_TARGET}
	${gscfmock_${EXAMPLES_BUILD_TYPE}_TARGET}
)
