/**********
Copyright (c) 2018, Xilinx, Inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice,
this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation
and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors
may be used to endorse or promote products derived from this software
without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**********/

#define N 128

//__kernel void __attribute__ ((reqd_work_group_size(1,1,1)))
void
krnl_vadd_core(
		__global int *a,
		__global int *b,
		__global int *c)
{
	int result[N];

	 {
	      int j;
	      read_a:
	          __attribute__((xcl_pipeline_loop))
	          for(j=0; j < N; j++)
	            result[j] = a[j];

	      read_b_write_c:	// simultaneously both read and write are supported
	            __attribute__((xcl_pipeline_loop))
	            for(j=0; j < N; j++)
	              c[j] = result[j] + b[j];
	    }

}

__kernel void __attribute__ ((reqd_work_group_size(1, 1, 1)))
krnl_vadd(
     __global int* a,
     __global int* b,
     __global int* c,
     const int length) {

  // optimized kernel code

  int iterations = length/N;
  for(int i=0; i < iterations; i++) {
	  krnl_vadd_core(a + i*N, b + i*N, c +i*N);
  }

     
  return;
}
