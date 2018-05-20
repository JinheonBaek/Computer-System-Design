/*
 * csd_main.c
 *
 *  Created on: 2018. 4. 25.
 *      Author: Taeweon Suh
 */

unsigned volatile int * gpio_led = (unsigned int *) 0x41200000;

int csd_main()
{

 int count;

 for (count=0; count < 0x1000000; count++) ;

 *gpio_led = 0xC3;

 for (count=0; count < 0x1000000; count++) ;

 *gpio_led = 0x3C;

 return 0;

}
