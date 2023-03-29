//+------------------------------------------------------------------+
//|                                                     Backtest.mqh |
//|                        Copyright 2023, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#include "Risk.mqh";
#include "Entry.mqh";
#include "Exit.mqh";
#include "Utility.mqh";
class CBacktest
  {
private:


public:
   CRisk             risk;
   CEntry            entry;
   CExit             exit;
   CUtility          util;
   void              backtest();
                     CBacktest();
                    ~CBacktest();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CBacktest::CBacktest()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CBacktest::~CBacktest()
  {
  }
//+------------------------------------------------------------------+
void CBacktest::backtest()
  {
   int startPos = Bars - 2880;
   int endPos = Bars - 1;

   for(int i = startPos; i <= endPos; i++)
     {
      double profit = 0;

      // Check for entry signal
      if(entry.OpenTradesUsingPivotPoint(i))
        {
         // Calculate position size
         double posSize = risk.calculatePositionSize(2,200);

         // Open trade
         int ticket = openTrade(posSize);

         // Manage trade
         manageTrade(ticket);
        }

      // Check for exit signal
      if(exitSignal(i))
        {
         // Close trade
         closeTrade(ticket);

         // Record profit
         profit = OrderProfit();
        }

      // Update performance metrics
      updateMetrics(profit);
     }

// Output performance report
   outputReport();
  }
//+------------------------------------------------------------------+
