/**  test text
***/

#include "stdio.h"
/*#include "conio.h"*/
#include "MIToolboxMex.h"

int X[7][1]={1,1,2,3,1,1,3};
int Y[7][1]={2,1,0,2,1,2,3};

int main()
{

	float output;
	int  mergedFirst[7][1];
	int  mergedSecond[7][1];
if (size(X,2)>1)
  mergedFirst = MIToolboxMex(3,X);
else
  mergedFirst = X;
end
if (size(Y,2)>1)
  mergedSecond = MIToolboxMex(3,Y);
else
  mergedSecond = Y;
end
[output] = MIToolboxMex(7,mergedFirst,mergedSecond);
printf("%d",output);
return 0;
}