//+------------------------------------------------------------------+
//|                                                       Master.mq4 |
//|                        Copyright 2023, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#include "Risk.mqh";
#include "entry/Entry.mqh";
#include "Main.mqh";
#include "Exit.mqh";
#include "Utility.mqh";
CMain main;
input string            seperator0="OVERALL SETTINGS";
input int               EntryType=0;                     //0 for Pivot, 1 for Breakout, 2 for MeanReversion
input bool              TrailingStopActivate=true;       //true for active, false for deactive

input string            seperator1="PIVOT STRATEGY SETTINGS";
input double            P_stoploss=200;
input double            P_takeprofit=300; 
input int               P_lookbackperiod=10;  
input double            P_riskpercent=2;           
input ENUM_TIMEFRAMES   P_timeframe=PERIOD_CURRENT;

input string            seperator2="BREAKOUT STRATEGY SETTINGS";
input double            BO_stoploss=200;
input double            BO_takeprofit=300;
input int               BO_lookbackperiod=10;
input double            BO_threshold=100;
input double            BO_riskpercent=2;
input ENUM_TIMEFRAMES   BO_timeframe=PERIOD_CURRENT;


input string            seperator3="MEAN REVERSION STRATEGY SETTINGS";
input double            MN_stoploss=200;
input double            MN_takeprofit=300;
input int               MN_lookbackperiod=10;
input double            MN_deviation=2;
input double            MN_riskpercent=2;
input ENUM_TIMEFRAMES   MN_timeframe=PERIOD_CURRENT;
/*
 1.  Entry function that generates the signal for trade to enter.
 2.  Trade management function that manages the open trades with using partial closing, trailing stop loss and dynamic take profit.
 3.  Risk management function that sets generic position sizes and manages the overall risk of the trading system.
 4.  Exit function that manages the exiting part of the trade.
 5.  Seasonal tendency function that utilizes the phenomenon that markets tend to move with seasonal movements every cycle within years.
 6.  Market scanning function that scans major pairs in Forex market to find applicable trades.
 7.  Backtesting function that allows the user to test the performance of the system on historical data.
 8.  Optimization function that allows the user to optimize the system's parameters for maximum profitability.
 9.  Reporting function that summarizes the performance of the system, including metrics such as profitability, drawdown, and win rate.
 10. Alert function that sends notifications to the user when a trade is entered, exited, or when certain conditions are met.
*/
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
      
      
      main.GetParams(EntryType,TrailingStopActivate,
                     P_stoploss,P_takeprofit,P_lookbackperiod,P_riskpercent,P_timeframe,
                     BO_stoploss,BO_takeprofit,BO_lookbackperiod,BO_threshold,BO_riskpercent,BO_timeframe,
                     MN_stoploss,MN_takeprofit,MN_lookbackperiod,MN_deviation,MN_riskpercent,MN_timeframe);
      
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
   main.Executer();
  }
//+------------------------------------------------------------------+
