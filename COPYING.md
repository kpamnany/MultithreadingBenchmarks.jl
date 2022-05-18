All files apart from those listed below use the MIT license.

All files in `src/comparative/OpenMP/` use the following license:

/*
Copyright (c) 2013, Intel Corporation

Redistribution and use in source and binary forms, with or without 
modification, are permitted provided that the following conditions 
are met:

    * Redistributions of source code must retain the above copyright 
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above 
      copyright notice, this list of conditions and the following 
      disclaimer in the documentation and/or other materials provided 
      with the distribution.
    * Neither the name of Intel Corporation nor the names of its 
      contributors may be used to endorse or promote products 
      derived from this software without specific prior written 
      permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS 
FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE 
COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, 
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, 
BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; 
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT 
LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN 
ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
POSSIBILITY OF SUCH DAMAGE.
*/

One file is based on the scaled vector add test (TRIAD) from the
STREAM benchmark.  WE have modified the code and do not follow the
STREAM run rules, hence the results from these programs cannot be 
reported as official STREAM results.

`src/comparative/OpenMP/nstream.c`

/* Copyright 1991-2013: John D. McCalpin                                 */
/*-----------------------------------------------------------------------*/
/* License:                                                              */
/*  1. You are free to use this program and/or to redistribute           */
/*     this program.                                                     */
/*  2. You are free to modify this program for your own use,             */
/*     including commercial use, subject to the publication              */
/*     restrictions in item 3.                                           */
/*  3. You are free to publish results obtained from running this        */
/*     program, or from works that you derive from this program,         */
/*     with the following limitations:                                   */
/*     3a. In order to be referred to as "STREAM benchmark results",     */
/*         published results must be in conformance to the STREAM        */
/*         Run Rules, (briefly reviewed below) published at              */
/*         http://www.cs.virginia.edu/stream/ref.html                    */
/*         and incorporated herein by reference.                         */
/*         As the copyright holder, John McCalpin retains the            */
/*         right to determine conformity with the Run Rules.             */
/*     3b. Results based on modified source code or on runs not in       */
/*         accordance with the STREAM Run Rules must be clearly          */
/*         labelled whenever they are published.  Examples of            */
/*         proper labelling include:                                     */
/*           "tuned STREAM benchmark results"                            */
/*           "based on a variant of the STREAM benchmark code"           */
/*         Other comparable, clear, and reasonable labelling is          */
/*         acceptable.                                                   */
/*     3c. Submission of results to the STREAM benchmark web site        */
/*         is encouraged, but not required.                              */
/*  4. Use of this program or creation of derived works based on this    */
/*     program constitutes acceptance of these licensing restrictions.   */
/*  5. Absolutely no warranty is expressed or implied.                   */
/*-----------------------------------------------------------------------*/

One file also utilizes the following license in addition to the BSD
2.0 license listed earlier in this file.
 
`src/comparative/OpenMP/random.c`

/*************************************************************
Copyright (c) 2013 The University of Tennessee. All rights reserved.
Redistribution and use in source and binary forms, with or 
without modification, are permitted provided that the following
conditions are met:�

� Redistributions of source code must retain the 
  above copyright notice, this list of conditions and 
  the following disclaimer.�

� Redistributions in binary form must reproduce the 
  above copyright notice, this list of conditions and 
  the following disclaimer listed in this license in the 
  documentation and/or other materials provided with the 
  distribution.�

� Neither the name of the copyright holders nor the names 
  of its contributors may be used to endorse or promote 
  products derived from this software without specific 
  prior written permission.

This software is provided by the copyright holders and 
contributors "as is" and any express or implied warranties, 
including, but not limited to, the implied warranties of
merchantability and fitness for a particular purpose are 
disclaimed. in no event shall the copyright owner or 
contributors be liable for any direct, indirect, incidental, 
special, exemplary, or consequential damages (including, but 
not limited to, procurement of substitute goods or services;
loss of use, data, or profits; or business interruption) 
however caused and on any theory of liability, whether in 
contract, strict liability, or tort (including negligence or 
otherwise) arising in any way out of the use of this software, 
even if advised of the possibility of such damage.

*************************************************************/
