//+------------------------------------------------------------------+
//|                                                         Exit.mqh |
//|                        Copyright 2023, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
class CExit
  {
private:

public:
   void              exitTrades();
                     CExit();
                    ~CExit();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExit::CExit()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExit::~CExit()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CExit::exitTrades()
  {
// Get current time
   datetime currentTime = TimeCurrent();

// Loop through all open orders
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
        {
         // Calculate time elapsed since order was opened
         int timeElapsed = (int)(currentTime - OrderOpenTime());

         // Calculate profit in percentage of account balance
         double accountBalance = AccountBalance();
         double orderProfit = OrderProfit();
         double profitPercentage = orderProfit / accountBalance * 100;

         // Check if order should be closed
         if(timeElapsed > 120 * 60 * 60 || profitPercentage >= 2)
           {
            if(OrderClose(OrderTicket(), OrderLots(), Bid, 3, White))
              {
               GetLastError();
              }
           }
         else
            if(profitPercentage >= 1)
              {
               // Calculate lot size for partial close
               double lotSize = OrderLots() / 2;
               if(!OrderClose(OrderTicket(), lotSize, Bid, 3, White))
                 {
                  GetLastError();
                 }
              }
        }
     }
  }
//+------------------------------------------------------------------+



/*
// Define global variables
double SAR;
double StopLoss;
double TrailingStop;

// Calculate initial stop loss and trailing stop
SAR = iSAR(Symbol(), 0, 0.02, 0.2);
StopLoss = NormalizeDouble(SAR - (4 * Point()), Digits);
TrailingStop = NormalizeDouble(SAR - (2 * Point()), Digits);

// Set the trailing stop for an open position
void SetTrailingStop(int ticket) {
    // Check if the position is still open
    if (OrderSelect(ticket, SELECT_BY_TICKET, MODE_TRADES)) {
        // Calculate the current Parabolic SAR value
        SAR = iSAR(Symbol(), 0, 0.02, 0.2);

        // Update the trailing stop
        TrailingStop = NormalizeDouble(SAR - (2 * Point()), Digits);

        // Set the trailing stop for the position
        if (OrderType() == OP_BUY) {
            // For a long position, set the stop loss at the current trailing stop
            StopLoss = TrailingStop;
            OrderModify(ticket, OrderOpenPrice(), StopLoss, OrderTakeProfit(), 0, clrRed);
        } else if (OrderType() == OP_SELL) {
            // For a short position, set the stop loss at the current trailing stop
            StopLoss = TrailingStop;
            OrderModify(ticket*/