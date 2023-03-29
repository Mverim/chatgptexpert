//+------------------------------------------------------------------+
//|                                                         Main.mqh |
//|                                                          M.Verim |
//|                 https://mysystematictradingjourney.blogspot.com/ |
//+------------------------------------------------------------------+
#property copyright "M.Verim"
#property link      "https://mysystematictradingjourney.blogspot.com/"
#property version   "1.00"
#property strict
/*
      CURRENT PLANS ????????????

      1. Make every entry function available and working.
            -Connect the inputs with their corresponding entry choice.
            -Entry files are inside a folder, first connect inputs to Entry.mqh then the entry types.
            -Add a flag for deactiveting not selected strategy types in terms of entry.
      2. Fix the executer to execute every bar once, it was executing twice or more a bar.
      3. Handle the notification sender function to send notification about the trade or exit with details.
            -Entering price, TP SL if set should be sent.
            -Would be great if this function sent general information(open positions, market stiuation) every 30 mins.
      4. Exit should be checked, perhaps a trailing stop could be implemented.
            -Research about the exit styles and try to implement several ways, which should reside in Exit.mqh.
      5. Try to manage this sub class class tree hierachy shit all together, its been a fucking torture honestly.

*/
#include "Risk.mqh";
#include "entry/Entry.mqh";
#include "Exit.mqh";
#include "Utility.mqh";
class CMain
{
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

   CRisk             risk;
   CEntry            entry;
   CExit             exit;
   CUtility          util;

   void              GetParams(int entrytype, bool trailingstop,
                               double pstoploss, double ptakeprofit, int plookback, double prisk, ENUM_TIMEFRAMES ptimeframe,
                               double bostoploss, double botakeprofit, int bolookback, double bothreshold, double borisk, ENUM_TIMEFRAMES botimeframe,
                               double mnstoploss, double mntakeprofit, int mnlookback, double mndeviation, double mnrisk, ENUM_TIMEFRAMES mntimeframe);

   void              SendParams();

   void              Executer();
   CMain();
   ~CMain();
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CMain::CMain()
{
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CMain::~CMain()
{
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void  CMain::Executer(void)
{
   if(util.ExecuteEveryBar(i_P_timeframe))
   {
      exit.exitTrades();
      PrintFormat("Executer got executed :)");
   }

}

//+------------------------------------------------------------------+
//|Function for sending inputs to proper sub classes                 |
//+------------------------------------------------------------------+
void CMain::SendParams(void)
{
   i_entrytype=entry.i_entrytype;
   i_trailingstopflag=entry.i_trailingstopflag;

   i_P_stoploss=entry.i_P_stoploss;
   i_P_takeprofit=entry.i_P_takeprofit;
   i_P_lookbackperiod=entry.i_P_lookbackperiod;
   i_P_riskpercent=entry.i_P_riskpercent;
   i_P_timeframe=entry.i_P_timeframe;

   i_BO_stoploss=entry.i_BO_stoploss;
   i_BO_takeprofit=entry.i_BO_takeprofit;
   i_BO_lookbackperiod=entry.i_BO_lookbackperiod;
   i_BO_threshold=entry.i_BO_threshold;
   i_BO_riskpercent=entry.i_BO_riskpercent;
   i_BO_timeframe=entry.i_BO_timeframe;

   i_MN_stoploss=entry.i_MN_stoploss;
   i_MN_takeprofit=entry.i_MN_takeprofit;
   i_MN_lookbackperiod=entry.i_MN_lookbackperiod;
   i_MN_deviation=entry.i_MN_deviation;
   i_MN_riskpercent=entry.i_MN_riskpercent;
   i_MN_timeframe=entry.i_MN_timeframe;

}
//+---------------------------------------------------------------------+
//|Function for getting inputs from expert advisor to send it to classes|
//+---------------------------------------------------------------------+
void CMain::GetParams(int entrytype, bool trailingstop,
                      double pstoploss, double ptakeprofit, int plookback, double prisk, ENUM_TIMEFRAMES ptimeframe,
                      double bostoploss, double botakeprofit, int bolookback, double bothreshold, double borisk, ENUM_TIMEFRAMES botimeframe,
                      double mnstoploss, double mntakeprofit, int mnlookback, double mndeviation, double mnrisk, ENUM_TIMEFRAMES mntimeframe)
{
   i_entrytype=entrytype;
   i_trailingstopflag=trailingstop;

   i_P_stoploss=pstoploss;
   i_P_takeprofit=ptakeprofit;
   i_P_lookbackperiod=plookback;
   i_P_riskpercent=prisk;
   i_P_timeframe=ptimeframe;

   i_BO_stoploss=bostoploss;
   i_BO_takeprofit=botakeprofit;
   i_BO_lookbackperiod=bolookback;
   i_BO_threshold=bothreshold;
   i_BO_riskpercent=borisk;
   i_BO_timeframe=botimeframe;

   i_MN_stoploss=mnstoploss;
   i_MN_takeprofit=mntakeprofit;
   i_MN_lookbackperiod=mnlookback;
   i_MN_deviation=mndeviation;
   i_MN_riskpercent=mnrisk;
   i_MN_timeframe=mntimeframe;
}

//+------------------------------------------------------------------+
