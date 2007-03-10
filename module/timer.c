// ----------------------------------------------------------------------------
// file: digital_input.c
// desc: digital input driver implementation
// ----------------------------------------------------------------------------

#include <pic18fregs.h>
#include "config.h"
#include "timer.h"

// ----------------------------------------------------------------------------
// private declarations 
// ----------------------------------------------------------------------------

typedef struct 
{
  char allocated;
  unsigned int value;
} timer_t;

timer_t timers[MAX_TIMER];

// ----------------------------------------------------------------------------
// public declarations
// ----------------------------------------------------------------------------

void timer_init()
{
  char i;

  for (i = 0; i < MAX_TIMER; i++)
  {
    timers[i].allocated = FALSE;
    timers[i].value     = 0;
  }
}

// ----------------------------------------------------------------------------

void timer_isr()
{
  char i;
  
  for (i = 0; i < MAX_TIMER; i++)
  {
    if ((timers[i].allocated == TRUE) && (timers[i].value > 0))
      timers[i].value--;
  }
}

// ----------------------------------------------------------------------------

char timer_alloc()
{
  char i;
  
  for (i = 0; i < MAX_TIMER; i++)
  {
    if (timers[i].allocated == FALSE)
    {
      timers[i].allocated = TRUE;
      return i;
    }
  }
  
  return INVALID_TIMER;
}

// ----------------------------------------------------------------------------

void timer_free(char timer)
{
  if ((timer < MAX_TIMER) && (timers[timer].allocated == TRUE))
  {
    timers[timer].allocated = FALSE;
    timers[timer].value     = 0;
  }
}

// ----------------------------------------------------------------------------

unsigned int timer_check(char timer)
{
  if ((timer < MAX_TIMER) && (timers[timer].allocated == TRUE))
    return timers[timer].value;
  else
    return 0;
}

// ----------------------------------------------------------------------------

void timer_set(char timer, unsigned int value)
{
  if ((timer < MAX_TIMER) && (timers[timer].allocated == TRUE))
    timers[timer].value = value;
}

/* EOF */
