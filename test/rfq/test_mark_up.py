from utils.calc import Calc


def compute_mark_up(quotes):
    compute_side = 1 if quotes['side'] == "buy" else -1
    if quotes['markup_type'] == 'bps':
        init_mark_up = Calc(((Calc(quotes['quote_price'])/Calc(quotes['raw_price'])) - 1) * compute_side * 10000)
        mark_up = str(round(float(str(init_mark_up))))
    elif quotes['markup_type'] == 'pips':
        init_mark_up = Calc((Calc(quotes['quote_price']) - Calc(quotes['raw_price'])) * compute_side * 10000)
        mark_up = str(round(float(str(init_mark_up))))
    else:
        init_mark_up = Calc((Calc(quotes['quote_price']) - Calc(quotes['raw_price'])) * compute_side)
        mark_up = str(Calc(str(round(float(str(init_mark_up)), 2))))

    quotes['mark_up'] = mark_up
    return quotes


if __name__ == '__main__':
    quotes = {
       'side': 'buy',
       'markup_type': 'pips',
       'raw_price': '0.4652',
       'quote_price': '0.4672',
    }
    quotes = compute_mark_up(quotes)
    print(quotes)
