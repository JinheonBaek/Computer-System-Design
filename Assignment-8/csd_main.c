/*
 * csd_main.c
 *
 *  Created on: 2018. 4. 30.
 *      Author: Taeweon Suh
 */

int csd_main()
{
	unsigned int * sw;
	sw = (unsigned *)0x41210000;

	long long epoch = 0x300000;

	for (int i = 0; i < epoch; i++);

	// If switch 0 is on, return 0 (enable caches)
	if ((*sw) == 0x1)
		return 0;
	else
		return 1;

}
