//+------------------------------------------------------------------+
//|                                               TradingDataLog.mq4 |
//|                                                       Dian Basit |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Dian Basit"
#property link      "https://www.mql5.com"
#property version   "1.1"
#property strict

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
input string Account_Name=""; // Name of your Account (NO SPACES)
input double Start_Day_Balance = 0; // Starting Day Balance (OPTIONAL)
input double Start_Day_Equity = 0; // Starting Day Equity (OPTIONAL)

// copy the inputs into these variables
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

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   accountName = Account_Name;
   startDayBalance = Start_Day_Balance;
   startDayEquity = Start_Day_Equity;

// if the values are 0 or negative then reset it to current balance or equity
   if(startDayBalance <= 0)
      startDayBalance = AccountBalance();
   if(startDayEquity <= 0)
      startDayEquity = AccountEquity();

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   currentDay = Day();
   currentMonth = Month();

   if(currentDay!=lastDay)
     {
      // this will always execute when program is installed initially
      lastDay = currentDay;
      if((currentDay < 10) && (currentMonth < 10)) // if both day and month are less than 10
         dateString = StringFormat("%d0%d0%d", Year(), Month(), Day());
      else if (currentDay < 10) // if only day is less than 10
         dateString = StringFormat("%d%d0%d", Year(), Month(), Day());
      else if (currentMonth < 10) // if only month is less than 10
         dateString = StringFormat("%d0%d%d", Year(), Month(), Day());
      else // if none are less than 10
         dateString = StringFormat("%d%d%d", Year(), Month(), Day());
      fileName = accountName+"_log_"+dateString+".csv"; // this is more important

      // update startday balance and equity
      startDayEquity = AccountEquity();
      startDayBalance = AccountBalance();

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
   double balance = AccountBalance();
   double equity = AccountEquity();
   double delta = equity - balance;
   if(balance > highestDayBalance)
      highestDayBalance = balance; // update highest balance
   if(balance < lowestDayBalance)
      lowestDayBalance = balance; // update lowest balance
   if(equity > highestDayEquity)
      highestDayEquity = equity; // update highest equity
   if(equity < lowestDayEquity)
      lowestDayEquity = equity; // update lowest equity
   double usedMargin = AccountMargin();
   double freeMargin = AccountFreeMargin();
   double differencePercentage = delta/balance * 100;

// Convert these to string to display values in csv
   string balanceString = DoubleToString(balance);
   string equityString = DoubleToString(equity);
   string deltaString = DoubleToString(delta);
   string differencePercentageString = DoubleToString(differencePercentage);
   string highestDayBalanceString = DoubleToString(highestDayBalance);
   string highestDayEquityString = DoubleToString(highestDayEquity);
   string lowestDayBalanceString = DoubleToString(lowestDayBalance);
   string lowestDayEquityString = DoubleToString(lowestDayEquity);
   string usedMarginString = DoubleToString(AccountMargin());
   string freeMarginString = DoubleToString(AccountFreeMargin());

   recordData(fileName, timeDate,  timeSeconds, balanceString, equityString, deltaString, differencePercentageString, highestDayBalanceString, lowestDayBalanceString, highestDayEquityString, lowestDayEquityString, usedMarginString, freeMarginString);

//recordData(file, fileName);
   drawLabel("0", fileName, 0, clrWhite);

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void recordData(string name, string date, string seconds, string balance, string equity, string delta, string diffPercentage, string highestBalance, string lowestBalance, string highestEquity, string lowestEquity, string usedMargin, string freeMargin)
  {
   int fileHandle = FileOpen(name, FILE_READ | FILE_WRITE | FILE_CSV | FILE_ANSI, ",");
   FileSeek(fileHandle, 0, SEEK_END);
   FileWrite(fileHandle, date, seconds, balance, equity, delta, diffPercentage, highestBalance, lowestBalance, highestEquity, lowestEquity, usedMargin, freeMargin);
   FileClose(fileHandle);
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void drawLabel(string id, string text, int objectIndex = 0, color colour = clrWhite, double xDistance = 30, int fontSize = 24, string font = "Arial Bold")
  {
   ObjectCreate(0, id, OBJ_LABEL, 0,0,0);
   ObjectSetText(id, text, fontSize, font, colour);
   ObjectSet(id, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSet(id, OBJPROP_XDISTANCE, 30);
// This will adjust number of labels in the next line
   ObjectSet(id, OBJPROP_YDISTANCE, (int)16*(1+objectIndex));
//ObjectSet(id, OBJPROP_YDISTANCE, 10);
  }
