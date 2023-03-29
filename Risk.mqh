//+------------------------------------------------------------------+
//|                                                         Risk.mqh |
//|                        Copyright 2023, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
class CRisk
  {
private:
   double            accountBalance;
   double            maxRisk;
   double            pointValue;
   double            stopLoss;
   double            positionSize;
   
public:
   double            calculatePositionSize(double riskPercent, double stopLossPips);
                     CRisk();
                    ~CRisk();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CRisk::CRisk()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CRisk::~CRisk()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CRisk::calculatePositionSize(double riskPercent, double stopLossPips)
  {
// Get account balance
   accountBalance = AccountBalance();

// Calculate maximum risk per trade in account currency
   maxRisk = accountBalance * (riskPercent / 100);

// Calculate stop loss distance in account currency
   pointValue = MarketInfo(Symbol(), MODE_POINT);
   stopLoss = stopLossPips * pointValue;

// Calculate position size based on maximum risk and stop loss distance
   positionSize = NormalizeDouble(maxRisk / stopLoss, 2);

   return positionSize;
  }


















//+------------------------------------------------------------------+
