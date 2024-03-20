#pragma once

#include <QtGlobal>
#include <sys/time.h>


namespace Clock
{
uint64_t getTime(const clockid_t & = CLOCK_MONOTONIC);
}
