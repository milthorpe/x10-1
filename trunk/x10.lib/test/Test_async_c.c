/*
 * (c) Copyright IBM Corporation 2007
 *
 * This file is part of X10 Runtime System.
 * Author : Ganesh Bikshandi
 */

/* $Id: Test_async_c.c,v 1.4 2007-09-13 15:20:04 ganeshvb Exp $ */

#include <x10/x10lib.h>


void async0 (x10_async_arg_t arg)
{
  assert (arg == 333);
}

void asyncSwitch (x10_async_handler_t h, void* args, int niter)
{
  switch (h) {
   case 0:
     async0 (*((x10_async_arg_t*) args));
     break;
  }
}

int 
main (int argc, char* argv[])
{

  x10_init(NULL, 0);

  if (x10_here() == 0)
    for (x10_place_t target = 0; target < x10_num_places(); target++)
       x10_async_spawn_inline (target, 0, 1, 333);

  x10_sync_global(); 

  printf ("Test_async_c PASSED\n");

  x10_finalize();

  return 0;
}
