/*
 *  csd_main.c
 *
 *  Created on: 2018. 4. 13.
 *      Author: Taeweon
 */

#pragma GCC target ("thumb")

int thumb_C_test(int a)
{
	int c;

	c = a + 0x11223343;

	return c;
}


#pragma GCC target ("arm")

int arm_C_test(int a)
{
	int c;

	c = a + 0x44332211;

	return c;
}
