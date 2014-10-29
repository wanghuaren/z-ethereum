package com.bellaxu.def
{
	import flash.utils.Dictionary;

	public final class KeyboardKeyDef
	{
		public static const INVALID:KeyboardKeyDef = new KeyboardKeyDef(0);
		public static const BACKSPACE:KeyboardKeyDef = new KeyboardKeyDef(8);
		public static const TAB:KeyboardKeyDef = new KeyboardKeyDef(9);
		public static const ENTER:KeyboardKeyDef = new KeyboardKeyDef(13);
		public static const COMMAND:KeyboardKeyDef = new KeyboardKeyDef(15);
		public static const SHIFT:KeyboardKeyDef = new KeyboardKeyDef(16);
		public static const CONTROL:KeyboardKeyDef = new KeyboardKeyDef(17);
		public static const ALT:KeyboardKeyDef = new KeyboardKeyDef(18);
		public static const PAUSE:KeyboardKeyDef = new KeyboardKeyDef(19);
		public static const CAPS_LOCK:KeyboardKeyDef = new KeyboardKeyDef(20);
		public static const ESCAPE:KeyboardKeyDef = new KeyboardKeyDef(27);
		public static const SPACE:KeyboardKeyDef = new KeyboardKeyDef(32);
		public static const PAGE_UP:KeyboardKeyDef = new KeyboardKeyDef(33);
		public static const PAGE_DOWN:KeyboardKeyDef = new KeyboardKeyDef(34);
		public static const END:KeyboardKeyDef = new KeyboardKeyDef(35);
		public static const HOME:KeyboardKeyDef = new KeyboardKeyDef(36);
		public static const LEFT:KeyboardKeyDef = new KeyboardKeyDef(37);
		public static const UP:KeyboardKeyDef = new KeyboardKeyDef(38);
		public static const RIGHT:KeyboardKeyDef = new KeyboardKeyDef(39);
		public static const DOWN:KeyboardKeyDef = new KeyboardKeyDef(40);
		public static const INSERT:KeyboardKeyDef = new KeyboardKeyDef(45);
		public static const DELETE:KeyboardKeyDef = new KeyboardKeyDef(46);
		public static const ZERO:KeyboardKeyDef = new KeyboardKeyDef(48);
		public static const ONE:KeyboardKeyDef = new KeyboardKeyDef(49);
		public static const TWO:KeyboardKeyDef = new KeyboardKeyDef(50);
		public static const THREE:KeyboardKeyDef = new KeyboardKeyDef(51);
		public static const FOUR:KeyboardKeyDef = new KeyboardKeyDef(52);
		public static const FIVE:KeyboardKeyDef = new KeyboardKeyDef(53);
		public static const SIX:KeyboardKeyDef = new KeyboardKeyDef(54);
		public static const SEVEN:KeyboardKeyDef = new KeyboardKeyDef(55);
		public static const EIGHT:KeyboardKeyDef = new KeyboardKeyDef(56);
		public static const NINE:KeyboardKeyDef = new KeyboardKeyDef(57);
		public static const A:KeyboardKeyDef = new KeyboardKeyDef(65);
		public static const B:KeyboardKeyDef = new KeyboardKeyDef(66);
		public static const C:KeyboardKeyDef = new KeyboardKeyDef(67);
		public static const D:KeyboardKeyDef = new KeyboardKeyDef(68);
		public static const E:KeyboardKeyDef = new KeyboardKeyDef(69);
		public static const F:KeyboardKeyDef = new KeyboardKeyDef(70);
		public static const G:KeyboardKeyDef = new KeyboardKeyDef(71);
		public static const H:KeyboardKeyDef = new KeyboardKeyDef(72);
		public static const I:KeyboardKeyDef = new KeyboardKeyDef(73);
		public static const J:KeyboardKeyDef = new KeyboardKeyDef(74);
		public static const K:KeyboardKeyDef = new KeyboardKeyDef(75);
		public static const L:KeyboardKeyDef = new KeyboardKeyDef(76);
		public static const M:KeyboardKeyDef = new KeyboardKeyDef(77);
		public static const N:KeyboardKeyDef = new KeyboardKeyDef(78);
		public static const O:KeyboardKeyDef = new KeyboardKeyDef(79);
		public static const P:KeyboardKeyDef = new KeyboardKeyDef(80);
		public static const Q:KeyboardKeyDef = new KeyboardKeyDef(81);
		public static const R:KeyboardKeyDef = new KeyboardKeyDef(82);
		public static const S:KeyboardKeyDef = new KeyboardKeyDef(83);
		public static const T:KeyboardKeyDef = new KeyboardKeyDef(84);
		public static const U:KeyboardKeyDef = new KeyboardKeyDef(85);
		public static const V:KeyboardKeyDef = new KeyboardKeyDef(86);
		public static const W:KeyboardKeyDef = new KeyboardKeyDef(87);
		public static const X:KeyboardKeyDef = new KeyboardKeyDef(88);
		public static const Y:KeyboardKeyDef = new KeyboardKeyDef(89);
		public static const Z:KeyboardKeyDef = new KeyboardKeyDef(90);
		public static const NUM0:KeyboardKeyDef = new KeyboardKeyDef(96);
		public static const NUM1:KeyboardKeyDef = new KeyboardKeyDef(97);
		public static const NUM2:KeyboardKeyDef = new KeyboardKeyDef(98);
		public static const NUM3:KeyboardKeyDef = new KeyboardKeyDef(99);
		public static const NUM4:KeyboardKeyDef = new KeyboardKeyDef(100);
		public static const NUM5:KeyboardKeyDef = new KeyboardKeyDef(101);
		public static const NUM6:KeyboardKeyDef = new KeyboardKeyDef(102);
		public static const NUM7:KeyboardKeyDef = new KeyboardKeyDef(103);
		public static const NUM8:KeyboardKeyDef = new KeyboardKeyDef(104);
		public static const NUM9:KeyboardKeyDef = new KeyboardKeyDef(105);
		public static const MULTIPLY:KeyboardKeyDef = new KeyboardKeyDef(106);
		public static const ADD:KeyboardKeyDef = new KeyboardKeyDef(107);
		public static const NUMENTER:KeyboardKeyDef = new KeyboardKeyDef(108);
		public static const SUBTRACT:KeyboardKeyDef = new KeyboardKeyDef(109);
		public static const DECIMAL:KeyboardKeyDef = new KeyboardKeyDef(110);
		public static const DIVIDE:KeyboardKeyDef = new KeyboardKeyDef(111);
		public static const F1:KeyboardKeyDef = new KeyboardKeyDef(112);
		public static const F2:KeyboardKeyDef = new KeyboardKeyDef(113);
		public static const F3:KeyboardKeyDef = new KeyboardKeyDef(114);
		public static const F4:KeyboardKeyDef = new KeyboardKeyDef(115);
		public static const F5:KeyboardKeyDef = new KeyboardKeyDef(116);
		public static const F6:KeyboardKeyDef = new KeyboardKeyDef(117);
		public static const F7:KeyboardKeyDef = new KeyboardKeyDef(118);
		public static const F8:KeyboardKeyDef = new KeyboardKeyDef(119);
		public static const F9:KeyboardKeyDef = new KeyboardKeyDef(120);
		public static const F11:KeyboardKeyDef = new KeyboardKeyDef(122);
		public static const F12:KeyboardKeyDef = new KeyboardKeyDef(123);
		public static const NUM_LOCK:KeyboardKeyDef = new KeyboardKeyDef(144);
		public static const SCROLL_LOCK:KeyboardKeyDef = new KeyboardKeyDef(145);
		public static const COLON:KeyboardKeyDef = new KeyboardKeyDef(186);
		public static const PLUS:KeyboardKeyDef = new KeyboardKeyDef(187);
		public static const COMMA:KeyboardKeyDef = new KeyboardKeyDef(188);
		public static const MINUS:KeyboardKeyDef = new KeyboardKeyDef(189);
		public static const PERIOD:KeyboardKeyDef = new KeyboardKeyDef(190);
		public static const BACKSLASH:KeyboardKeyDef = new KeyboardKeyDef(191);
		public static const TILDE:KeyboardKeyDef = new KeyboardKeyDef(192);
		public static const LEFT_BRACKET:KeyboardKeyDef = new KeyboardKeyDef(219);
		public static const SLASH:KeyboardKeyDef = new KeyboardKeyDef(220);
		public static const RIGHT_BRACKET:KeyboardKeyDef = new KeyboardKeyDef(221);
		public static const QUOTE:KeyboardKeyDef = new KeyboardKeyDef(222);
		
		private static var _typeMap:Dictionary = null;
		
		private var _keyCode:int = 0;
		
		public function KeyboardKeyDef(code:int=0)
		{
			this._keyCode = code;
		}
		
		public static function get staticTypeMap():Dictionary
		{
			if (!_typeMap){
				_typeMap = new Dictionary();
				_typeMap["BACKSPACE"] = BACKSPACE;
				_typeMap["TAB"] = TAB;
				_typeMap["ENTER"] = ENTER;
				_typeMap["RETURN"] = ENTER;
				_typeMap["SHIFT"] = SHIFT;
				_typeMap["COMMAND"] = COMMAND;
				_typeMap["CONTROL"] = CONTROL;
				_typeMap["ALT"] = ALT;
				_typeMap["OPTION"] = ALT;
				_typeMap["ALTERNATE"] = ALT;
				_typeMap["PAUSE"] = PAUSE;
				_typeMap["CAPS_LOCK"] = CAPS_LOCK;
				_typeMap["ESCAPE"] = ESCAPE;
				_typeMap["SPACE"] = SPACE;
				_typeMap["SPACE_BAR"] = SPACE;
				_typeMap["PAGE_UP"] = PAGE_UP;
				_typeMap["PAGE_DOWN"] = PAGE_DOWN;
				_typeMap["END"] = END;
				_typeMap["HOME"] = HOME;
				_typeMap["LEFT"] = LEFT;
				_typeMap["UP"] = UP;
				_typeMap["RIGHT"] = RIGHT;
				_typeMap["DOWN"] = DOWN;
				_typeMap["LEFT_ARROW"] = LEFT;
				_typeMap["UP_ARROW"] = UP;
				_typeMap["RIGHT_ARROW"] = RIGHT;
				_typeMap["DOWN_ARROW"] = DOWN;
				_typeMap["INSERT"] = INSERT;
				_typeMap["DELETE"] = DELETE;
				_typeMap["ZERO"] = ZERO;
				_typeMap["ONE"] = ONE;
				_typeMap["TWO"] = TWO;
				_typeMap["THREE"] = THREE;
				_typeMap["FOUR"] = FOUR;
				_typeMap["FIVE"] = FIVE;
				_typeMap["SIX"] = SIX;
				_typeMap["SEVEN"] = SEVEN;
				_typeMap["EIGHT"] = EIGHT;
				_typeMap["NINE"] = NINE;
				_typeMap["0"] = ZERO;
				_typeMap["1"] = ONE;
				_typeMap["2"] = TWO;
				_typeMap["3"] = THREE;
				_typeMap["4"] = FOUR;
				_typeMap["5"] = FIVE;
				_typeMap["6"] = SIX;
				_typeMap["7"] = SEVEN;
				_typeMap["8"] = EIGHT;
				_typeMap["9"] = NINE;
				_typeMap["NUMBER_0"] = ZERO;
				_typeMap["NUMBER_1"] = ONE;
				_typeMap["NUMBER_2"] = TWO;
				_typeMap["NUMBER_3"] = THREE;
				_typeMap["NUMBER_4"] = FOUR;
				_typeMap["NUMBER_5"] = FIVE;
				_typeMap["NUMBER_6"] = SIX;
				_typeMap["NUMBER_7"] = SEVEN;
				_typeMap["NUMBER_8"] = EIGHT;
				_typeMap["NUMBER_9"] = NINE;
				_typeMap["A"] = A;
				_typeMap["B"] = B;
				_typeMap["C"] = C;
				_typeMap["D"] = D;
				_typeMap["E"] = E;
				_typeMap["F"] = F;
				_typeMap["G"] = G;
				_typeMap["H"] = H;
				_typeMap["I"] = I;
				_typeMap["J"] = J;
				_typeMap["K"] = K;
				_typeMap["L"] = L;
				_typeMap["M"] = M;
				_typeMap["N"] = N;
				_typeMap["O"] = O;
				_typeMap["P"] = P;
				_typeMap["Q"] = Q;
				_typeMap["R"] = R;
				_typeMap["S"] = S;
				_typeMap["T"] = T;
				_typeMap["U"] = U;
				_typeMap["V"] = V;
				_typeMap["W"] = W;
				_typeMap["X"] = X;
				_typeMap["Y"] = Y;
				_typeMap["Z"] = Z;
				_typeMap["NUM0"] = NUM0;
				_typeMap["NUM1"] = NUM1;
				_typeMap["NUM2"] = NUM2;
				_typeMap["NUM3"] = NUM3;
				_typeMap["NUM4"] = NUM4;
				_typeMap["NUM5"] = NUM5;
				_typeMap["NUM6"] = NUM6;
				_typeMap["NUM7"] = NUM7;
				_typeMap["NUM8"] = NUM8;
				_typeMap["NUM9"] = NUM9;
				_typeMap["NUMPAD_0"] = NUM0;
				_typeMap["NUMPAD_1"] = NUM1;
				_typeMap["NUMPAD_2"] = NUM2;
				_typeMap["NUMPAD_3"] = NUM3;
				_typeMap["NUMPAD_4"] = NUM4;
				_typeMap["NUMPAD_5"] = NUM5;
				_typeMap["NUMPAD_6"] = NUM6;
				_typeMap["NUMPAD_7"] = NUM7;
				_typeMap["NUMPAD_8"] = NUM8;
				_typeMap["NUMPAD_9"] = NUM9;
				_typeMap["MULTIPLY"] = MULTIPLY;
				_typeMap["ASTERISK"] = MULTIPLY;
				_typeMap["NUMMULTIPLY"] = MULTIPLY;
				_typeMap["NUMPAD_MULTIPLY"] = MULTIPLY;
				_typeMap["ADD"] = ADD;
				_typeMap["NUMADD"] = ADD;
				_typeMap["NUMPAD_ADD"] = ADD;
				_typeMap["SUBTRACT"] = SUBTRACT;
				_typeMap["NUMSUBTRACT"] = SUBTRACT;
				_typeMap["NUMPAD_SUBTRACT"] = SUBTRACT;
				_typeMap["DECIMAL"] = DECIMAL;
				_typeMap["NUMDECIMAL"] = DECIMAL;
				_typeMap["NUMPAD_DECIMAL"] = DECIMAL;
				_typeMap["DIVIDE"] = DIVIDE;
				_typeMap["NUMDIVIDE"] = DIVIDE;
				_typeMap["NUMPAD_DIVIDE"] = DIVIDE;
				_typeMap["NUMENTER"] = NUMENTER;
				_typeMap["NUMPAD_ENTER"] = NUMENTER;
				_typeMap["F1"] = F1;
				_typeMap["F2"] = F2;
				_typeMap["F3"] = F3;
				_typeMap["F4"] = F4;
				_typeMap["F5"] = F5;
				_typeMap["F6"] = F6;
				_typeMap["F7"] = F7;
				_typeMap["F8"] = F8;
				_typeMap["F9"] = F9;
				_typeMap["F11"] = F11;
				_typeMap["F12"] = F12;
				_typeMap["NUM_LOCK"] = NUM_LOCK;
				_typeMap["SCROLL_LOCK"] = SCROLL_LOCK;
				_typeMap["COLON"] = COLON;
				_typeMap["SEMICOLON"] = COLON;
				_typeMap["PLUS"] = PLUS;
				_typeMap["EQUAL"] = PLUS;
				_typeMap["COMMA"] = COMMA;
				_typeMap["LESS_THAN"] = COMMA;
				_typeMap["MINUS"] = MINUS;
				_typeMap["UNDERSCORE"] = MINUS;
				_typeMap["PERIOD"] = PERIOD;
				_typeMap["GREATER_THAN"] = PERIOD;
				_typeMap["BACKSLASH"] = BACKSLASH;
				_typeMap["QUESTION_MARK"] = BACKSLASH;
				_typeMap["TILDE"] = TILDE;
				_typeMap["BACK_QUOTE"] = TILDE;
				_typeMap["LEFT_BRACKET"] = LEFT_BRACKET;
				_typeMap["LEFT_BRACE"] = LEFT_BRACKET;
				_typeMap["SLASH"] = SLASH;
				_typeMap["FORWARD_SLASH"] = SLASH;
				_typeMap["PIPE"] = SLASH;
				_typeMap["RIGHT_BRACKET"] = RIGHT_BRACKET;
				_typeMap["RIGHT_BRACE"] = RIGHT_BRACKET;
				_typeMap["QUOTE"] = QUOTE;
			}
			return _typeMap;
		}
		
		public static function codeToString(value:int):String
		{
			var key:String;
			var dict:Dictionary = staticTypeMap;
			for (key in dict) 
			{
				if (staticTypeMap[key.toUpperCase()].keyCode == value)
				{
					return key.toUpperCase();
				}
			}
			return null;
		}
		
		public static function stringToCode(value:String):int
		{
			if (!staticTypeMap[value.toUpperCase()])
			{
				return 0;
			}
			return staticTypeMap[value.toUpperCase()].keyCode;
		}
		
		public static function stringToKey(value:String):KeyboardKeyDef
		{
			return staticTypeMap[value.toUpperCase()];
		}
		
		public function get keyCode():int
		{
			return this._keyCode;
		}
		
		public function get typeMap():Dictionary
		{
			return staticTypeMap;
		}
	}
}