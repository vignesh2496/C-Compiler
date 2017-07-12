
#include <stdio.h>

int func(int a , int b)
{
	return 0;
}

int main()		
{
	// Single Line Comment
	int var = 6; 
	int a,b,c,array[100];
	array[var] = 12;
	a = b + c;
	for(var = 10; var <= 100; var++)
	{
		int temp = 0;
		  
		func(temp*var,var);
		
		/* Multi-line
		Comment */
	}

	int temp = 0;
	while(temp < 10)
	{
		int h = 8;
		if(h)
		{
			temp = temp + 1 ;
		}
		else
		{
			temp--;
		}
	}

	int count = 0;
	do
	{
		count++;
	} while(count<=20);

	return 0;
}
