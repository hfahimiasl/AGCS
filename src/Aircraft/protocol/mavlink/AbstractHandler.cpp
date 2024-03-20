#include "AbstractHandler.h"


AbstractHandler::AbstractHandler(MAVLink *_mavlink) :
	mavlink(_mavlink)
{}

AbstractHandler::~AbstractHandler()
{}
