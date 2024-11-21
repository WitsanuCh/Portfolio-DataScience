import MetaTrader5 as mt5
import pandas as pd
from datetime import datetime
import time 
import pandas_ta as ta

# Data
def get_data(ticker, tf):
    data = mt5.copy_rates_from(ticker, tf, datetime.now(), 50)

    df = pd.DataFrame(data)
    df['time'] = pd.to_datetime(df['time'], unit='s')

    return df
    
def get_latest(ticker, tf):
    data = mt5.copy_rates_from(ticker, tf, datetime.now(), 1)

    df= pd.DataFrame(data)
    df['time'] = pd.to_datetime(df['time'], unit='s')

    df_last = df

    return df_last

# Strategy
def strategy(df, atr_length, sma_length):

    df.ta.atr(length=atr_length, append=True)
    df.ta.sma(close = 'close', length=sma_length, append=True)

    df['upper_band'] = df['SMA_' + str(sma_length)] + 1.5 * df['ATRr_' + str(atr_length)]
    df['lower_band'] = df['SMA_' + str(sma_length)] - 1.5 * df['ATRr_' + str(atr_length)]

    df['buy_signal'] = (df['low'].shift(1) < df['lower_band']) & (df['close'] > df['lower_band'])
    df['sell_signal'] = (df['high'].shift(1)  > df['upper_band']) & (df['close'] < df['upper_band'])

    return df  

# Execution
def place_order(ticker, lot, open_side): #คำสั่ง Place
    if open_side == "buy":

        type_order = mt5.ORDER_TYPE_BUY
        price = mt5.symbol_info_tick(ticker).ask

    elif open_side == "sell":
        
        type_order = mt5.ORDER_TYPE_SELL
        price = mt5.symbol_info_tick(ticker).bid

    request_o = {
        "action":mt5.TRADE_ACTION_DEAL,
        "symbol":ticker,
        "volume":lot,
        "type":type_order,
        "price":price,
        "deviation":20,
        "magic":234000,
        "comment": "place by python",
        "type_time": mt5.ORDER_TIME_GTC,
        "type_filling": mt5.ORDER_FILLING_IOC
    }

    return request_o

def close_order(order_type, ticker, lot, order_id): #คำสั่ง Close
    if order_type == "close_buy":

        type_order = mt5.ORDER_TYPE_SELL
        price = mt5.symbol_info_tick(ticker).bid

    elif order_type == "close_sell":
        
        type_order = mt5.ORDER_TYPE_BUY
        price = mt5.symbol_info_tick(ticker).ask

    request_c = {
        "action":mt5.TRADE_ACTION_DEAL,
        "symbol":ticker,
        "position":order_id,
        "volume":lot,
        "type":type_order,
        "price":price,
        "deviation":20,
        "comment": "place by python",
        "type_time": mt5.ORDER_TIME_GTC,
        "type_filling": mt5.ORDER_FILLING_IOC
    }

    return request_c

def execution_open(open_side, df, ticker, lot):

    opened_order = mt5.positions_total()

    if(open_side == "buy"):
        if(df['buy_signal'].values[0] == True) and (opened_order == 0):

            request_o = place_order(ticker, lot, open_side)
            result = mt5.order_send(request_o)
            time.sleep(3)

            print(f'Place Buy {result.volume} at {result.price}')

        else:
            print("No Action")
    elif (open_side == "sell"):

        if (df['sell_signal'].values[0] == True) and (opened_order == 0):

            request_o = place_order(ticker , lot ,open_side)
            result = mt5.order_send(request_o)

            time.sleep(3)

            print(f'Place Sell {result.volume} at {result.price}')

        else:
            print("No Action")

def execution_close(order_type, df ,ticker ,lot):
    opened_order = mt5.positions_total()

    if (order_type == "close_buy") and opened_order != 0:
        order_id = mt5.positions_get(symbol="XAUUSD")[0].ticket
        type_o = mt5.positions_get(symbol="XAUUSD")[0].type

        if (df['sell_signal'].values[0] == True) and (type_o == 0 and order_id !=None):

            request_c = close_order(order_type, ticker, lot, order_id)
            result = mt5.order_send(request_c)

            print(f'Close Buy order_id {order_id} status {result.comment}')
        
        else:
            print('No Action')

    elif (order_type == "close_sell") and opened_order !=0 :

        order_id = mt5.positions_get(symbol=ticker)[0].tickets
        type_o = mt5.positions_get(symbol=ticker)[0].type

        if (df['buy_signal'].values[0] == True) and (type_o == 1 and order_id != None):

            request_c = close_order(order_type, ticker, lot, order_id)
            result = mt5.order_send(request_c)

            print(f'Close sell order_id {order_id} status {result.comment}')

        else:
            print('No Action')

    else:
        print('No Action')

def main():

    print("***SYSTEM START ***")

    mt5.initialize()

    #Basic Config
    ticker = "XAUUSD"
    tf = mt5.TIMEFRAME_M1
    lot = 0.01
    open_side = "sell"
    order_type = "close_sell"

    #Credentials
    username = "xxxxxx"
    password = "xxxxx"
    server = "xxxxxx"

    #Strategy
    atr_length = 7
    sma_length = 11

    mt5.login(username, password, server)

    df = get_data(ticker, tf)

    df = strategy(df, atr_length, sma_length)

    print(df)

    execution_open(open_side, df.tail(1), ticker, lot)
    execution_close(order_type, df.tail(1), ticker, lot)

    print("***SLEEP MODE***")


    while True:
        time.sleep(60-time.time()%60)

        df_latest = get_latest(ticker, tf)
        df = pd.concat([df, df_latest])

        df = strategy(df, atr_length, sma_length)

        print(df)

        execution_open(open_side, df.tail(1), ticker, lot)
        execution_close(order_type, df.tail(1), ticker, lot)

        print("***SLEEP MODE***")
main()
