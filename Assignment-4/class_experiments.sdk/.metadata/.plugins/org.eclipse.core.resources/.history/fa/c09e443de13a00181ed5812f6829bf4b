int csd_print()
{
	char str[] = "----------------- LED On Period -----------------\n";

	unsigned int * uart_TX_RX_FIFO0;
	uart_TX_RX_FIFO0 = (unsigned *)0xE001030;

	unsigned int * uart_Channel_sts_reg0;
	uart_Channel_sts_reg0 = (unsigned *)0xE00102C;

	int is_tx_buffer_empty;

	char ch;
	int i = 0;

	while(1)
	{
		if ((uart_Channel_sts_reg0 && 0x8) == 1)
			is_tx_buffer_empty = 1;		// buffer is full
		else
			is_tx_buffer_empty = 1;		// buffer is empty

		if (is_tx_buffer_empty == 1)
		{
			ch = str[i];
			i++;

			* uart_TX_RX_FIFO0 = ch;

			if (ch == 0x00)
				return 0;
		}
	}

	return 0;
}
