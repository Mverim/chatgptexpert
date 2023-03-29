//+------------------------------------------------------------------+
//|                                                      Utility.mqh |
//|                        Copyright 2023, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#include "Risk.mqh";
class CUtility {
 private:
 public:
   double            lookbackHigh(int lookbackBars);
   double            lookbackLow(int lookbackBars);

   double            EfficiencyRatio(int period);

   void              openOrder(double size, double price, double stoploss, double takeprofit, string comment, int magic);

   void              ScanMarkets();

   void              sendNotification(string message);

   bool              ExecuteEveryBar(ENUM_TIMEFRAMES period);
   CUtility();
   ~CUtility();
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CUtility::CUtility() {
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CUtility::~CUtility() {
}
//+------------------------------------------------------------------+
//|  PERRY KAUFMAN EFFICIENCY RATIO                                  |
//+------------------------------------------------------------------+
double CUtility::EfficiencyRatio(int period) {
   double price_change = MathAbs(iClose(_Symbol, 0, period) - iClose(_Symbol, 0, 1));
   double ATR = iATR(_Symbol, 0, period, 0);
   double efficiency_ratio = price_change / ATR;
   return efficiency_ratio;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CUtility::ExecuteEveryBar(ENUM_TIMEFRAMES period) {
// Executes every bar in chosen period
   static datetime last_bar_time = 0;
   datetime current_bar_time = iTime(_Symbol, period, 0);
   if(current_bar_time != last_bar_time) {
      return true;
      last_bar_time = current_bar_time;
   } else
      return false;
}
//+------------------------------------------------------------------+
// Function to scan major forex pairs for potential trades           |
//+------------------------------------------------------------------+
void CUtility::ScanMarkets() {

// Define array of major forex pairs
   string pairs[7] = {"EURUSD", "USDJPY", "GBPUSD", "USDCHF", "AUDUSD", "USDCAD", "NZDUSD"};

// Loop through each pair in the array
   for(int i=0; i<ArraySize(pairs); i++) {

      // Get the current price for the pair
      double price = SymbolInfoDouble(pairs[i], SYMBOL_BID);

      // Calculate the pivot points for the pair
      double pivot = (iHigh(pairs[i], PERIOD_D1, 1) + iLow(pairs[i], PERIOD_D1, 1) + iClose(pairs[i], PERIOD_D1, 1)) / 3;
      double r1 = 2 * pivot - iLow(pairs[i], PERIOD_D1, 1);
      double r2 = pivot + (iHigh(pairs[i], PERIOD_D1, 1) - iLow(pairs[i], PERIOD_D1, 1));
      double s1 = 2 * pivot - iHigh(pairs[i], PERIOD_D1, 1);
      double s2 = pivot - (iHigh(pairs[i], PERIOD_D1, 1) - iLow(pairs[i], PERIOD_D1, 1));

      // Check if the current price is above the pivot point
      if(price > pivot) {
         // Generate a signal to go long
         // You can call your entry function here passing the required parameters
         // For example: MyEntryFunction(pairs[i], "long", pivot, r1, r2, s1, s2);
      }
      // Check if the current price is below the pivot point
      else if(price < pivot) {
         // Generate a signal to go short
         // You can call your entry function here passing the required parameters
         // For example: MyEntryFunction(pairs[i], "short", pivot, r1, r2, s1, s2);
      }
   }
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CUtility::sendNotification(string message) {
   string notification_subject = "ChatGPTExpert Alert: ";
   SendNotification(notification_subject+message);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CUtility::openOrder(double size, double price, double stoploss, double takeprofit, string comment, int magic) {

   if(!OrderSend(Symbol(),0,size,price,5,stoploss,takeprofit,comment,magic,0,clrNONE)) GetLastError();
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CUtility::lookbackHigh(int lookbackBars) {
   double highestHigh = -1;
   for(int i = 1; i <= lookbackBars; i++) {
      double high = High[i];
      if(high > highestHigh) {
         highestHigh = high;
      }
   }
   return highestHigh;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CUtility::lookbackLow(int lookbackBars) {
   double lowestLow = 999999;
   for(int i = 1; i <= lookbackBars; i++) {
      double low = Low[i];
      if(low < lowestLow) {
         lowestLow = low;
      }
   }
   return lowestLow;
}
//+------------------------------------------------------------------+
