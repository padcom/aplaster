// ----------------------------------------------------------------------------
// file: digin.c
// desc: digital input driver implementation
// ----------------------------------------------------------------------------

#include <pic18fregs.h>
#include "config.h"
#include "timer.h"
#include "digout.h"

// ----------------------------------------------------------------------------
// private declarations 
// ----------------------------------------------------------------------------

// ----------------------------------------------------------------------------
// public declarations
// ----------------------------------------------------------------------------

void digout_open()
{
  TRISC = 0x00; // all pins from PORTC are outputs
}

// ----------------------------------------------------------------------------

void digout_close(void)
{
  // nothing to be done
}

// ----------------------------------------------------------------------------

void digout_setstate(unsigned char channel, unsigned char state)
{
  unsigned char V = PORTC;
  if (state)
    V |= (1 << channel);
  else
    V &= ~(1 << channel);
  PORTC = V;
}

// ----------------------------------------------------------------------------

unsigned int digout_state(int channel)
{
  if (PORTC && (1 << channel))
    return 1;
  else
    return 0;
}

/* EOF */
