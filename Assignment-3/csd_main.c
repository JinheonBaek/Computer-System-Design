int csd_main()
{
	unsigned int * sw;
	sw = (unsigned *)0x41210000;

	long long epoch = 0;

	if ((*sw) >= 0x80)
		epoch = 0x888888;		// roughly 100 msec
	else if ((*sw) >= 0x40)
		epoch = 0x1111110;
	else if ((*sw) >= 0x20)
		epoch = 0x1999998;
	else if ((*sw) >= 0x10)
		epoch = 0x2222220;
	else if ((*sw) >= 0x8)
		epoch = 0x2AAAAA8;
	else if ((*sw) >= 0x4)
		epoch = 0x3333330;
	else if ((*sw) >= 0x2)
		epoch = 0x3BBBBB8;
	else if ((*sw) >= 0x1)
		epoch = 0x4444440;
	else if ((*sw) >= 0x0)
		epoch = 0x5555550;

	for (int i = 0; i < epoch; i++);

	return 0;
}
