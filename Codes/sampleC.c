
#include <stdio.h>

int func(int a , int b)
{
	return 0;
}

int main()		
{
	// Single Line Comment
	int var;
	int a,b,c;
	a = b + c;
	for(var = 10; var <= 100; var++,var--)
	{
		int temp = 0;
		  
		//fun(temp,var);     
		func(temp,var);
		while(10)
		{
			temp = temp + 1 ;
		}
		
		/* Multi-line
		Comment */
		int a[43],f;

		//func[3]=7;
		//g=6;
		//a=6;
		func(a[f],a[f]);
		do
		{
			temp = temp + 10 * var;
			if(temp > 100)
			{
				printf("%d", temp);
			}
			else
			{
				printf("%d", var); 
			}
		
		} while(temp < 10000);

	}

	return 0;
}
