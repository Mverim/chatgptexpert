//+------------------------------------------------------------------+
//|                                                        Pivot.mqh |
//|                                                          M.Verim |
//|                 https://mysystematictradingjourney.blogspot.com/ |
//+------------------------------------------------------------------+
#property copyright "M.Verim"
#property link      "https://mysystematictradingjourney.blogspot.com/"
#property version   "1.00"
#property strict
#include "../Risk.mqh";
#include "../Utility.mqh";
#include "Entry.mqh";
class CPivot
{
private:
   CUtility          util;
   CRisk             risk;
public:
   // Pivot Strategy inputs
   double            i_P_stoploss;
   double            i_P_takeprofit;
   int               i_P_lookbackperiod;
   double            i_P_riskpercent;
   ENUM_TIMEFRAMES   i_P_timeframe;
   
   double            pivot;
   double            support1;
   double            support2;
   double            resistance1;
   double            resistance2;
   double            previousHigh;
   double            previousLow;
   double            previousClose;

   double            CalculatePivot(double previousH, double previousL, double previousC);
   double            CalculateSupport1(double piv, double previousH, double previousL);
   double            CalculateSupport2(double piv, double support);
   double            CalculateResistance1(double piv, double previousH, double previousL);
   double            CalculateResistance2(double piv, double resistance);
   void              OpenTradesUsingPivotPoint(int i=0, ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT);
   CPivot();
   ~CPivot();
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CPivot::CPivot()
{
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CPivot::~CPivot()
{
}

//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
// Pivot point technique entry functions                             |
//+------------------------------------------------------------------+
double CPivot::CalculatePivot(double previousH, double previousL, double previousC)
{
   pivot = (previousH + previousL + previousC) / 3;
   return pivot;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CPivot::CalculateSupport1(double piv, double previousH, double previousL)
{
   support1 = (2 * piv) - previousH;
   return support1;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CPivot::CalculateSupport2(double piv, double support)
{
   support2 = piv - (support1 - piv);
   return support2;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CPivot::CalculateResistance1(double piv, double previousH, double previousL)
{
   resistance1 = (2 * pivot) - previousLow;
   return resistance1;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CPivot::CalculateResistance2(double piv, double resistance)
{
   resistance2 = piv + (resistance - piv);
   return resistance2;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CPivot::OpenTradesUsingPivotPoint(int i, ENUM_TIMEFRAMES timeframe)
{
// Get previous day's high, low and close
   previousHigh = iHigh(Symbol(), PERIOD_M15, i+1);
   previousLow = iLow(Symbol(), PERIOD_M15, i+1);
   previousClose = iClose(Symbol(), PERIOD_M15, i+1);

// Calculate pivot point and support/resistance levels
   pivot = CalculatePivot(previousHigh, previousLow, previousClose);
   support1 = CalculateSupport1(pivot, previousHigh, previousLow);
   support2 = CalculateSupport2(pivot, support1);
   resistance1 = CalculateResistance1(pivot, previousHigh, previousLow);
   resistance2 = CalculateResistance2(pivot, resistance1);
   PrintFormat("pivot: %.4f", pivot);
   PrintFormat("support1: %.4f", support1);
   PrintFormat("support2: %.4f", support2);
   PrintFormat("resistance1: %.4f", resistance1);
   PrintFormat("resistance2: %.4f", resistance2);

// Check if price is above pivot point and support levels for a long trade
   if(Close[i] > pivot && Close[i] > support1)
   {
      // Open long trade
      double lotSize = risk.calculatePositionSize(2, 200); // Generic position size
      double stopLoss = pivot - (support1 - pivot); // Stop loss at support 2
      double takeProfit = resistance1; // Take profit at resistance 1
      if(!OrderSend(Symbol(), OP_BUY, lotSize, Ask, 0, stopLoss, takeProfit, "Pivot Point Long", 0, 0, Green))
      {
         GetLastError();
      }
   }
// Check if price is below pivot point and resistance levels for a short trade
   else if(Close[i] < pivot && Close[i] < resistance1)
   {
      // Open short trade
      double lotSize = 0.1; // Generic position size
      double stopLoss = resistance1 + (pivot - resistance1); // Stop loss at resistance 2
      double takeProfit = support1; // Take profit at support 1
      if(!OrderSend(Symbol(), OP_SELL, lotSize, Bid, 0, stopLoss, takeProfit, "Pivot Point Short", 0, 0, Red))
      {
         GetLastError();
      }
   }
}
//+------------------------------------------------------------------+
