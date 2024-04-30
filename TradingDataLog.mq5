#property copyright "Suleman Basit"
#property link "https://www.mql5.com"
#property version "1.0"
#property strict

input string Account_Name = "";
input double Start_Day_Balance = 0;
input double Start_Day_Equity = 0;

string accountName = Account_Name;
double startDayEquity;
double startDayBalance;

int currentDay;
int currentMonth;
int lastDay = -1;
string dateString;
string fileName;
double highestDayBalance;
double lowestDayBalance;
double highestDayEquity;
double lowestDayEquity;

int OnInit()
{
    accountName=Account_Name;
    startDayBalance = Start_Day_Balance;
    startDayEquity = Start_Day_Equity;

    if (startDayBalance <= 0) startDayBalance = AccountInfoDouble(ACCOUNT_BALANCE);
    if (startDayEquity <= 0) startDayEquity = AccountInfoDouble(ACCOUNT_EQUITY);

    return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason)
{
//---

}

void OnTick()
{
   //---
   currentDay = TimeDay(TimeCurrent());
   currentMonth = TimeMonth(TimeCurrent());

   if(currentDay != lastDay)
   {
      // this will always execute when the program is installed initially
      lastDay = currentDay;
      if((currentDay < 10) && (currentMonth < 10)) // if both day and month are less than 10
         dateString = StringFormat("%d0%d0%d", TimeYear(TimeCurrent()), TimeMonth(TimeCurrent()), TimeDay(TimeCurrent()));
      else if (currentDay < 10) // if only day is less than 10
         dateString = StringFormat("%d%d0%d", TimeYear(TimeCurrent()), TimeMonth(TimeCurrent()), TimeDay(TimeCurrent()));
      else if (currentMonth < 10) // if only month is less than 10
         dateString = StringFormat("%d0%d%d", TimeYear(TimeCurrent()), TimeMonth(TimeCurrent()), TimeDay(TimeCurrent()));
      else // if none are less than 10
         dateString = StringFormat("%d%d%d", TimeYear(TimeCurrent()), TimeMonth(TimeCurrent()), TimeDay(TimeCurrent()));
      fileName = accountName+"_log_"+dateString+".csv"; // this is more important

      // update start day balance and equity
      startDayEquity = AccountInfoDouble(ACCOUNT_EQUITY);
      startDayBalance = AccountInfoDouble(ACCOUNT_BALANCE);

      // set highest balance and equity according to start day
      highestDayBalance = startDayBalance;
      highestDayEquity = startDayEquity;

      // set lowest balance and equity according to start day
      lowestDayBalance = startDayBalance;
      lowestDayEquity = startDayEquity;

      // make a new file here
      recordData(fileName, "Date", "Time", "Balance", "Equity", "Delta", "% Difference", "Highest Balance", "Lowest Balance", "Highest Equity", "Lowest Equity", "Used Margin", "Free Margin");
   }

   // Get these string and double values of critical information
   string timeDate = TimeToString(TimeCurrent(), TIME_DATE);
   string timeSeconds = TimeToString(TimeCurrent(), TIME_SECONDS);
   double balance = AccountInfoDouble(ACCOUNT_BALANCE);
   double equity = AccountInfoDouble(ACCOUNT_EQUITY);
   double delta = equity - balance;
   if(balance > highestDayBalance)
      highestDayBalance = balance; // update highest balance
   if(balance < lowestDayBalance)
      lowestDayBalance = balance; // update lowest balance
   if(equity > highestDayEquity)
      highestDayEquity = equity; // update highest equity
   if(equity < lowestDayEquity)
      lowestDayEquity = equity; // update lowest equity
   double usedMargin = AccountInfoDouble(ACCOUNT_MARGIN);
   double freeMargin = AccountInfoDouble(ACCOUNT_FREEMARGIN);
   double differencePercentage = delta / balance * 100;

   // Convert these to string to display values in CSV
   string balanceString = DoubleToString(balance);
   string equityString = DoubleToString(equity);
   string deltaString = DoubleToString(delta);
   string differencePercentageString = DoubleToString(differencePercentage);
   string highestDayBalanceString = DoubleToString(highestDayBalance);
   string highestDayEquityString = DoubleToString(highestDayEquity);
   string lowestDayBalanceString = DoubleToString(lowestDayBalance);
   string lowestDayEquityString = DoubleToString(lowestDayEquity);
   string usedMarginString = DoubleToString(usedMargin);
   string freeMarginString = DoubleToString(freeMargin);

   recordData(fileName, timeDate,  timeSeconds, balanceString, equityString, deltaString, differencePercentageString, highestDayBalanceString, lowestDayBalanceString, highestDayEquityString, lowestDayEquityString, usedMarginString, freeMarginString);

   // recordData(file, fileName);
   ObjectCreate(0, "Label_0", OBJ_LABEL, 0, 0, 0);
   ObjectSetString(0, "Label_0", OBJPROP_TEXT, fileName);
   ObjectSetInteger(0, "Label_0", OBJPROP_COLOR, clrWhite);
}

void recordData(string name, string date, string seconds, string balance, string equity, string delta, string diffPercentage, string highestBalance, string lowestBalance, string highestEquity, string lowestEquity, string usedMargin, string freeMargin)
{
   int fileHandle = FileOpen(name, FILE_READ | FILE_WRITE | FILE_CSV | FILE_ANSI, ',');
   if(fileHandle != INVALID_HANDLE)
   {
      FileSeek(fileHandle, 0, SEEK_END);
      string dataRow = date + "," + seconds + "," + balance + "," + equity + "," + delta + "," + diffPercentage + "," + highestBalance + "," + lowestBalance + "," + highestEquity + "," + lowestEquity + "," + usedMargin + "," + freeMargin;
      FileWrite(fileHandle, dataRow);
      FileClose(fileHandle);
   }
}

void drawLabel(string id, string text, int objectIndex = 0, color colour = clrWhite, double xDistance = 30, int fontSize = 24, string font = "Arial Bold")
{
   ObjectCreate(0, id, OBJ_LABEL, 0, 0, 0);
   ObjectSetText(id, text, fontSize, font, colour);
   ObjectSetInteger(0, id, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetDouble(0, id, OBJPROP_XDISTANCE, xDistance);
   ObjectSetInteger(0, id, OBJPROP_YDISTANCE, 16 * (1 + objectIndex));
}
