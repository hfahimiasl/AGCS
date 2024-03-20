#include "Clock.h"


uint64_t Clock::getTime(const clockid_t &clock_id)
{
	struct timespec ts {};
	clock_gettime(clock_id, &ts);
	return uint64_t(ts.tv_sec) * 1000000ULL + uint64_t((ts.tv_nsec + 500) / 1000);
}
