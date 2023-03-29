//+------------------------------------------------------------------+
//|                                                MeanReversion.mqh |
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
class CMeanReversion
{
private:
public:

   // Mean Reversion Strategy inputs
   double            i_MN_stoploss;
   double            i_MN_takeprofit;
   int               i_MN_lookbackperiod;
   double            i_MN_deviation;
   double            i_MN_riskpercent;
   ENUM_TIMEFRAMES   i_MN_timeframe;

   bool          MeanReversionSignal(double &price[], int period, double deviation, int shift);

   CMeanReversion();
   ~CMeanReversion();
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CMeanReversion::CMeanReversion()
{
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CMeanReversion::~CMeanReversion()
{
}
//+------------------------------------------------------------------+
bool CMeanReversion::MeanReversionSignal(double &price[], int period, double deviation, int shift)
{
   double ma = iMA(NULL, 0, period, 0, MODE_SMA, PRICE_CLOSE, shift);
   double std = MathSqrt(iStdDev(NULL, 0, period, 0, MODE_SMA, PRICE_CLOSE, shift));
   double upper = ma + deviation * std;
   double lower = ma - deviation * std;

   if(price[shift] > upper)
   {
      return true; // Sell Signal
   }
   else if(price[shift] < lower)
   {
      return true; // Buy Signal
   }
   else
   {
      return false; // No Signal
   }
}
//+------------------------------------------------------------------+
