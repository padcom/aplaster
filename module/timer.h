// ----------------------------------------------------------------------------
// file: timer.h
// desc: timer definitions
// ----------------------------------------------------------------------------

#ifndef _TIMER_H
#define _TIMER_H

// ----------------------------------------------------------------------------

#define INVALID_TIMER        255
#define FALSE                0
#define TRUE                 1

#ifndef MAX_TIMER
  #define MAX_TIMER          16
#endif

// ----------------------------------------------------------------------------
// timers subsystem initialization
// ----------------------------------------------------------------------------
void timer_init();

// ----------------------------------------------------------------------------
// timers subsystem ISR
// ----------------------------------------------------------------------------
void timer_isr();

// ----------------------------------------------------------------------------
// allocate a timer.
// returns INVALID_TIMER if no timers are available
// ----------------------------------------------------------------------------
char timer_alloc();

// ----------------------------------------------------------------------------
// dispose a previously allocated timer
// timer - timer id (return value from timer_alloc)
// ----------------------------------------------------------------------------
void timer_free(char timer);

// ----------------------------------------------------------------------------
// gets the current timer value (it gets decremented every 10ms)
// timer - timer id (return value from timer_alloc)
// returns 0 if the timer is done, a positive value otherwise
// ----------------------------------------------------------------------------
unsigned int timer_check(char timer);

// ----------------------------------------------------------------------------
// initialize an allocated timer
// timer - timer id (return value from timer_alloc)
// value - a timeout value
// ----------------------------------------------------------------------------
void timer_set(char timer, unsigned int value);

#endif /* _IMER_H */
