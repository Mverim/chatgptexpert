//+------------------------------------------------------------------+
//|                                                        Entry.mqh |
//|                        Copyright 2023, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#include "Breakout.mqh";
#include "MeanReversion.mqh";
#include "Pivot.mqh";
#include "../Risk.mqh";
#include "../Utility.mqh";
class CEntry
{
private:

private:

public:
   // General inputs
   int               i_entrytype;
   bool              i_trailingstopflag;

   // Pivot Strategy inputs
   double            i_P_stoploss;
   double            i_P_takeprofit;
   int               i_P_lookbackperiod;
   double            i_P_riskpercent;
   ENUM_TIMEFRAMES   i_P_timeframe;

   // Breakout Strategy inputs
   double            i_BO_stoploss;
   double            i_BO_takeprofit;
   int               i_BO_lookbackperiod;
   double            i_BO_threshold;
   double            i_BO_riskpercent;
   ENUM_TIMEFRAMES   i_BO_timeframe;

   // Mean Reversion Strategy inputs
   double            i_MN_stoploss;
   double            i_MN_takeprofit;
   int               i_MN_lookbackperiod;
   double            i_MN_deviation;
   double            i_MN_riskpercent;
   ENUM_TIMEFRAMES   i_MN_timeframe;

   void              EntryConfiguration();

   CPivot            pivot;
   CBreakout         breakout;
   CMeanReversion    meanreversion;
   CRisk             risk;
   CUtility          util;
   CEntry();
   ~CEntry();
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CEntry::CEntry()
{
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CEntry::~CEntry()
{
}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CEntry::EntryConfiguration(void)
{
   switch(i_entrytype)
   {
   case 0:
      i_P_stoploss=pivot.i_P_stoploss;
      i_P_takeprofit=pivot.i_P_takeprofit;
      i_P_lookbackperiod=pivot.i_P_lookbackperiod;
      i_P_riskpercent=pivot.i_P_riskpercent;
      i_P_timeframe=pivot.i_P_timeframe;
      Print("Pivot strategy is active.");
      break;

   case 1:
      i_BO_stoploss=breakout.i_BO_stoploss;
      i_BO_takeprofit=breakout.i_BO_takeprofit;
      i_BO_lookbackperiod=breakout.i_BO_lookbackperiod;
      i_BO_threshold=breakout.i_BO_threshold;
      i_BO_riskpercent=breakout.i_BO_riskpercent;
      i_BO_timeframe=breakout.i_BO_timeframe;
      Print("Breakout strategy is active.");
      break;

   case 2:
      i_MN_stoploss=meanreversion.i_MN_stoploss;
      i_MN_takeprofit=meanreversion.i_MN_takeprofit;
      i_MN_lookbackperiod=meanreversion.i_MN_lookbackperiod;
      i_MN_deviation=meanreversion.i_MN_deviation;
      i_MN_riskpercent=meanreversion.i_MN_riskpercent;
      i_MN_timeframe=meanreversion.i_MN_timeframe;
      Print("Mean reversion strategy is active.");
      break;
   }
}




















//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
// Pivot point technique entry functions                             |
//+------------------------------------------------------------------+
/*double CEntry::CalculatePivot(double previousH, double previousL, double previousC) {
   pivot = (previousH + previousL + previousC) / 3;
   return pivot;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CEntry::CalculateSupport1(double piv, double previousH, double previousL) {
   support1 = (2 * piv) - previousH;
   return support1;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CEntry::CalculateSupport2(double piv, double support) {
   support2 = piv - (support1 - piv);
   return support2;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CEntry::CalculateResistance1(double piv, double previousH, double previousL) {
   resistance1 = (2 * pivot) - previousLow;
   return resistance1;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CEntry::CalculateResistance2(double piv, double resistance) {
   resistance2 = piv + (resistance - piv);
   return resistance2;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CEntry::OpenTradesUsingPivotPoint(int i,ENUM_TIMEFRAMES timeframe) {
// Get previous day's high, low and close
   double previousHigh = iHigh(Symbol(),PERIOD_M15,i+1);
   double previousLow = iLow(Symbol(),PERIOD_M15,i+1);
   double previousClose = iClose(Symbol(),PERIOD_M15,i+1);

// Calculate pivot point and support/resistance levels
   double pivot = CalculatePivot(previousHigh, previousLow, previousClose);
   double support1 = CalculateSupport1(pivot, previousHigh, previousLow);
   double support2 = CalculateSupport2(pivot, support1);
   double resistance1 = CalculateResistance1(pivot, previousHigh, previousLow);
   double resistance2 = CalculateResistance2(pivot, resistance1);
   PrintFormat("pivot: %.4f",pivot);
   PrintFormat("support1: %.4f",support1);
   PrintFormat("support2: %.4f",support2);
   PrintFormat("resistance1: %.4f",resistance1);
   PrintFormat("resistance2: %.4f",resistance2);

// Check if price is above pivot point and support levels for a long trade
   if(Close[i] > pivot && Close[i] > support1) {
      // Open long trade
      double lotSize = risk.calculatePositionSize(2,200); // Generic position size
      double stopLoss = pivot - (support1 - pivot); // Stop loss at support 2
      double takeProfit = resistance1; // Take profit at resistance 1
      if(!OrderSend(Symbol(), OP_BUY, lotSize, Ask, 0, stopLoss, takeProfit, "Pivot Point Long", 0, 0, Green)) {
         GetLastError();
      }
   }
// Check if price is below pivot point and resistance levels for a short trade
   else if(Close[i] < pivot && Close[i] < resistance1) {
      // Open short trade
      double lotSize = 0.1; // Generic position size
      double stopLoss = resistance1 + (pivot - resistance1); // Stop loss at resistance 2
      double takeProfit = support1; // Take profit at support 1
      if(!OrderSend(Symbol(), OP_SELL, lotSize, Bid, 0, stopLoss, takeProfit, "Pivot Point Short", 0, 0, Red)) {
         GetLastError();
      }
   }
}*/
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
// Mean Reversion Trading Signal Function                            |
//+------------------------------------------------------------------+
/*
bool CEntry::MeanReversionSignal(double &price[], int period, double deviation, int shift) {
   double ma = iMA(NULL, 0, period, 0, MODE_SMA, PRICE_CLOSE, shift);
   double std = MathSqrt(iStdDev(NULL, 0, period, 0, MODE_SMA, PRICE_CLOSE, shift));
   double upper = ma + deviation * std;
   double lower = ma - deviation * std;

   if(price[shift] > upper) {
      return true; // Sell Signal
   } else if(price[shift] < lower) {
      return true; // Buy Signal
   } else {
      return false; // No Signal
   }
}*/
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
// Breakout Signal                                                   |
//+------------------------------------------------------------------+
/*
void CEntry::breakoutSignal(int lookbackBars) {
   double lastHigh = util.lookbackHigh(lookbackBars);
   double lastLow = util.lookbackLow(lookbackBars);

   positionSize = risk.calculatePositionSize(2,200);

   if(High[0] > lastHigh) {
      // Generate buy signal
      Print("Buy signal - High of last ", lookbackBars, " bars broken: ", High[0]);
   } else if(Low[0] < lastLow) {
      // Generate sell signal
      Print("Sell signal - Low of last ", lookbackBars, " bars broken: ", Low[0]);
   }
}
//+------------------------------------------------------------------+
*/


/*
   void              breakoutSignal(int lookbackBars);

   bool              MeanReversionSignal(double &price[], int period, double deviation=2, int shift=0);

   double            CalculatePivot(double previousH, double previousL, double previousC);
   double            CalculateSupport1(double piv, double previousH, double previousL);
   double            CalculateSupport2(double piv, double support);
   double            CalculateResistance1(double piv, double previousH, double previousL);
   double            CalculateResistance2(double piv, double resistance);
*/
// void              OpenTradesUsingPivotPoint(int i=0,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT);




























//+------------------------------------------------------------------+
