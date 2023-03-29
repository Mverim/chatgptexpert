//+------------------------------------------------------------------+
//|                                                     Breakout.mqh |
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
class CBreakout
{
private:
   CUtility    util;
   CRisk       risk;
public:

   // Breakout Strategy inputs
   double            i_BO_stoploss;
   double            i_BO_takeprofit;
   int               i_BO_lookbackperiod;
   double            i_BO_threshold;
   double            i_BO_riskpercent;
   ENUM_TIMEFRAMES   i_BO_timeframe;
   
   void    breakoutSignal(int lookbackBars);
   
   CBreakout();
   ~CBreakout();
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CBreakout::CBreakout()
{
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CBreakout::~CBreakout()
{
}
//+------------------------------------------------------------------+
void CBreakout::breakoutSignal(int lookbackBars)
{
   double lastHigh = util.lookbackHigh(lookbackBars);
   double lastLow = util.lookbackLow(lookbackBars);

   double positionSize = risk.calculatePositionSize(2, 200);

   if(High[0] > lastHigh)
   {
      // Generate buy signal
      Print("Buy signal - High of last ", lookbackBars, " bars broken: ", High[0]);
   }
   else if(Low[0] < lastLow)
   {
      // Generate sell signal
      Print("Sell signal - Low of last ", lookbackBars, " bars broken: ", Low[0]);
   }
}
//+------------------------------------------------------------------+
