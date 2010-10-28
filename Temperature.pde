int Temperature(int pin)
{
  int iReads[4];
  int i;
  float temp;
  
  for(i=0;i<4;i++)
  {
     iReads[i] = analogRead(pin);
     delay(10);
  }

  for (int i = 1; i < 4; ++i)
  {
    int iCur = iReads[i];
    int t;
    for (t = i - 1; (t >= 0) && (iCur < iReads[t]); t--)
    {
      iReads[t + 1] = iReads[t];
    }
    iReads[t + 1] = iCur;
  }
  

   return (iReads[1] + iReads[2])/2;
}
