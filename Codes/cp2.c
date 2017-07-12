#include <stdio.h>
/* function declaration */
int max(int num1,int num2);
int main() {
/* local variable definition */
int a=100,b=a+20.0;
double ret=max(a,b);
printf("Max value is:%d\n",ret);
}
/* function returning the max between two numbers */
void max(int num1,int num2) {
printf("Max value is:%d\n",num1);
}
