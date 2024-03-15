//+------------------------------------------------------------------+
//|                                               TradingDataLog.mq4 |
//|                                                       Dian Basit |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Dian Basit"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

input string Account_Name="";

string accountName = Account_Name;

int currentDay;
int lastDay = -1;
string dateString;
string fileName;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   accountName = Account_Name;
//lastDay = Day();
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
//string date;
//if (Day()<10) date = StringFormat("%d%d0%d", Year(), Month(), Day());
//else date = StringFormat("%d%d%d", Year(), Month(), Day());
//Comment(date);
   currentDay = Day();

   if(currentDay!=lastDay)
     {
      lastDay = currentDay;
      if(currentDay < 10)
         dateString = StringFormat("%d%d0%d", Year(), Month(), Day());
      else
         dateString = StringFormat("%d%d%d", Year(), Month(), Day());
      fileName = accountName+"_log_"+dateString+".csv"; // this is more important
      // make a new file here
      recordData(fileName, "Time", "Equity", "Balance", "Delta");

     }
   string time = TimeToString(TimeCurrent(), TIME_DATE | TIME_SECONDS);
   double balance = AccountBalance();
   double equity = AccountEquity();
   double delta = balance - equity;
   
   string balanceString = DoubleToString(balance);
   string equityString = DoubleToString(equity);
   string deltaString = DoubleToString(delta);
   
   recordData(fileName, time,  equityString, balanceString, deltaString);

//recordData(file, fileName);
   Comment(fileName);

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void recordData(string name, string time, string equity, string balance, string delta)
  {
   int fileHandle = FileOpen(name, FILE_READ | FILE_WRITE | FILE_CSV | FILE_ANSI, ",");
   FileSeek(fileHandle, 0, SEEK_END);
   FileWrite(fileHandle, time, equity, balance, delta);
   FileClose(fileHandle);
  }
//+------------------------------------------------------------------+
