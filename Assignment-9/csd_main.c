int csd_main(int duration)
{
	long long epoch = 0;

	if (duration == 49)
		epoch = 0x888888;		// roughly 100 msec
	else if (duration == 50)
		epoch = 0x1111110;
	else if (duration == 51)
		epoch = 0x1999998;
	else if (duration == 52)
		epoch = 0x2222220;
	else if (duration == 53)
		epoch = 0x2AAAAA8;
	else if (duration == 54)
		epoch = 0x3333330;
	else if (duration == 55)
		epoch = 0x3BBBBB8;
	else if (duration == 56)
		epoch = 0x4444440;
	else if (duration == 57)
		epoch = 0x5555550;
	else
		epoch = 0x5555550;

	for (int i = 0; i < epoch; i++);

	return 0;
}
