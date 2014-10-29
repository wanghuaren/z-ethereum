package common.utils
{
	import common.config.GameIni;
	import common.managers.Lang;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.filters.ColorMatrixFilter;
	import flash.system.System;
	import netc.Data;
	import netc.packets2.StructItemAttr2;

	//suhang   操作工具类
	public final class StringUtils
	{
		public function StringUtils()
		{
		}

		//去左右空格;
		public static function trim(char:String, noEnter:Boolean=true):String
		{
			if (char == null)
			{
				return null;
			}
			if (noEnter)
				char=trimEnter(char);
			return rtrim(ltrim(char));
		}

		//去左空格; 
		public static function ltrim(char:String):String
		{
			if (char == null)
			{
				return null;
			}
			var pattern:RegExp=/^\s*/;
			return char.replace(pattern, "");
		}

		//去右空格;
		public static function rtrim(char:String):String
		{
			if (char == null)
			{
				return null;
			}
			var pattern:RegExp=/\s*$/;
			return char.replace(pattern, "");
		}

		//去掉回车
		public static function trimEnter(char:String):String
		{
			return char.replace(/[\r\n]/g, "")
		}

		//按钮不可用
		public static function setUnEnable(mcObj:Object, enabled:Boolean=false):void
		{
			if (mcObj == null)
				return;
			if (mcObj.hasOwnProperty("mouseEnabled"))
				mcObj.mouseEnabled=enabled;
			CtrlFactory.getUIShow().setBtnEnabled(mcObj as InteractiveObject, false);
		}

		public static function setUnEnableByColor(mcObj:Object, matrixArr:Array, enabled:Boolean=false):void
		{
			if (mcObj.hasOwnProperty("mouseEnabled"))
			{
				mcObj.mouseEnabled=enabled;
			}
			if (mcObj.hasOwnProperty("mouseChildren"))
			{
				mcObj.mouseChildren=enabled;
			}
			var filterObj:ColorMatrixFilter=new ColorMatrixFilter();
			filterObj.matrix=matrixArr.concat();
			mcObj.filters=[filterObj];
		}

		//按钮可用
		public static function setEnable(mcObj:Object):void
		{
			if(mcObj==null)return;
			if (mcObj.hasOwnProperty("mouseEnabled"))
				mcObj.mouseEnabled=true;
			//mcObj.mouseChildren = true;
			mcObj.filters=[];
		}

		public static function initEquipIcon(item:DisplayObject):void
		{
			if (item == null)
				return;
			if (item.hasOwnProperty("qianghua"))
				item["qianghua"].gotoAndStop(1);
			if (item.hasOwnProperty("huoyan"))
				item["huoyan"].gotoAndStop(1);
			if (item.hasOwnProperty("shanbian"))
				item["shanbian"].gotoAndStop(1);
		}

		//StringUtils.initEquipIcon(e.getInfo as DisplayObject);
		//StringUtils.setEquipIcon(e.getInfo as DisplayObject, MainDrag.currData);
		public static function setEquipIcon(item:DisplayObject, obj:Object):void
		{
			var enhace:int=int(obj.enhace);
			if (enhace == 0)
			{
				enhace=int(obj.strong_level);
			}
			if (enhace > 0 && enhace < 13 && item.hasOwnProperty("qianghua"))
			{
				item["qianghua"].gotoAndStop(2);
				//item["qianghua"]["num"].text = enhace + "";
				item["qianghua"]["num"].text=enhace.toString();
			}
			else if (enhace >= 13 && item.hasOwnProperty("qianghua"))
			{
				item["qianghua"].gotoAndStop(3);
			}
			if (enhace > 5 && enhace < 10)
			{
				item["huoyan"].gotoAndStop(2);
			}
			else if (enhace > 9 && enhace < 13)
			{
				item["huoyan"].gotoAndStop(3);
			}
			else if (enhace >= 13)
			{
				item["huoyan"].gotoAndStop(4);
			}
			if (int(obj.color) >= 3 || int(obj.equip_color) >= 3 || int(obj.res_color) >= 3)
			{
				item["shanbian"].gotoAndStop(2);
			}
			if (obj.hasOwnProperty("gem1") && int(obj.gem1) >= 6 && int(obj.gem2) >= 6 && int(obj.gem3) >= 6)
			{
				item["qianghua"].gotoAndStop(4);
			}
		}

		/**
		 * 通过一个毫秒数转换成时间字符串  add by steven guo
		 * @param timems
		 * @return
		 *
		 */
		public static function getStringTime(timems:Number, isEn:Boolean=true, showS:Boolean=false):String
		{
			var ms:int=int(timems % 1000); //毫秒 
			timems/=1000;
			var ss:int=int(timems % 60); // 秒 
			timems/=60;
			var MM:int=int(timems % 60); // 分 
			timems/=60;
			var hh:int=int(timems); // 小时 
			var _strSS:String=null;
			var _strMM:String=null;
			var _strHH:String=null;
			if (ss < 10)
			{
				_strSS="0" + ss;
			}
			else
			{
				_strSS="" + ss;
			}
			if (MM < 10)
			{
				_strMM="0" + MM;
			}
			else
			{
				_strMM="" + MM;
			}
			if (hh < 10)
			{
				_strHH="0" + hh;
			}
			else
			{
				_strHH="" + hh;
			}
			var _ret:String=null;
			if (isEn)
			{
				//_ret = hh+':'+MM+':'+ss+'.'+ms;
				//_ret = hh+':'+MM+':'+ss;
				_ret=hh + ':' + MM;
				if (showS)
					_ret+=(":" + ss);
			}
			else
			{
				//_ret = hh+"小时"+MM+"分钟";+ss+"秒";
				_ret=hh + Lang.getLabel("pub_shi") + MM + Lang.getLabel("pub_fen");
				if (showS)
					_ret+=(ss + Lang.getLabel("pub_miao"));
			}
			return _ret;
		}

		public static function getStringDayTimeX(date:Date):String
		{
			var _h:String="";
			var _m:String="";
			var _s:String="";
			if (date.hours < 10)
			{
				_h="0" + date.hours.toString();
			}
			else
			{
				_h=date.hours.toString();
			}
			if (date.minutes < 10)
			{
				_m="0" + date.minutes.toString();
			}
			else
			{
				_m=date.minutes.toString();
			}
			if (date.seconds < 10)
			{
				_s="0" + date.seconds.toString();
			}
			else
			{
				_s=date.seconds.toString();
			}
			return _h + ":" + _m + ":" + _s;
		}

		/**
		 *  通过一个毫秒数转换成日期时间字符串////如果某个单位为0，则省略
		 * @param timems
		 * @param isEn
		 * @return
		 *
		 */
		public static function getStringJianhuaTime(timems:Number, isEn:Boolean=true):String
		{
			var ms:int=int(timems % 1000); //毫秒 
			timems/=1000;
			var ss:int=int(timems % 60); // 秒 
			timems/=60;
			var MM:int=int(timems % 60); // 分 
			timems/=60;
			var hh:int=int(timems % 24); // 小时 
			timems/=24;
			var date:int=int(timems);
			var bd:Boolean=false;
			var bh:Boolean=false;
			var bm:Boolean=false;
			var bs:Boolean=false;
			var _strSS:String=null;
			var _strMM:String=null;
			var _strHH:String=null;
			if (ss < 10)
			{
				_strSS="0" + ss;
			}
			else
			{
				_strSS="" + ss;
			}
			if (MM < 10)
			{
				_strMM="0" + MM;
			}
			else
			{
				_strMM="" + MM;
			}
			if (hh < 10)
			{
				_strHH="0" + hh;
			}
			else
			{
				_strHH="" + hh;
			}
			var _ret:String="";
			if (isEn)
			{
				if (date > 0)
				{
					_ret=date + ":" + _strHH + ":" + _strMM + ":" + _strSS;
				}
				else if (hh > 0)
				{
					_ret=_strHH + ":" + _strMM + ":" + _strSS;
				}
				else
				{
					_ret=_strMM + ":" + _strSS;
				}
			}
			else
			{
				if (date > 0)
				{
					_ret+=date + Lang.getLabel("pub_tian");
					bd=true;
				}
				if (hh > 0 || bd)
				{
					_ret+=hh + Lang.getLabel("pub_shi");
					bh=true;
				}
				if (MM > 0 || bd || bh)
				{
					_ret+=MM + Lang.getLabel("pub_fen");
					bh=true;
				}
				if (ss > 0 || bd || bh || bm)
				{
					_ret+=ss + Lang.getLabel("pub_miao");
				}
			}
			return _ret;
		}

		/**
		 *  通过一个毫秒数转换成日期时间字符串
		 * @param timems
		 * @param isEn
		 * @return
		 *
		 */
		public static function getStringDayTime(timems:Number, isEn:Boolean=true):String
		{
			var ms:int=int(timems % 1000); //毫秒 
			timems/=1000;
			var ss:int=int(timems % 60); // 秒 
			timems/=60;
			var MM:int=int(timems % 60); // 分 
			timems/=60;
			var hh:int=int(timems % 24); // 小时 
			timems/=24;
			var date:int=int(timems);
			var _strSS:String=null;
			var _strMM:String=null;
			var _strHH:String=null;
			if (ss < 10)
			{
				_strSS="0" + ss;
			}
			else
			{
				_strSS="" + ss;
			}
			if (MM < 10)
			{
				_strMM="0" + MM;
			}
			else
			{
				_strMM="" + MM;
			}
			if (hh < 10)
			{
				_strHH="0" + hh;
			}
			else
			{
				_strHH="" + hh;
			}
			var _ret:String="";
			if (isEn)
			{
				if (date > 0)
				{
					_ret=date + ":" + _strHH + ":" + _strMM + ":" + _strSS;
				}
				else if (hh > 0)
				{
					_ret=_strHH + ":" + _strMM + ":" + _strSS;
				}
				else
				{
					_ret=_strMM + ":" + _strSS;
				}
			}
			else
			{
				if (date >= 0)
				{
					_ret+=date + Lang.getLabel("pub_tian");
				}
				if (hh >= 0)
				{
					_ret+=hh + Lang.getLabel("pub_shi");
				}
				if (MM >= 0)
				{
					_ret+=MM + Lang.getLabel("pub_fen");
				}
				if (ss >= 0)
				{
					_ret+=ss + Lang.getLabel("pub_miao");
				}
			}
			return _ret;
		}

		/**
		 * 格式20120101  转化成 Date 对象
		 * @param iDate
		 *
		 */
		public static function iDateToDate(iDate:int):Date
		{
			var _year:int=iDate / 10000;
			if (_year <= 0)
			{
				_year=1970;
			}
			var _temp:int=iDate % 10000;
			var _month:int=_temp / 100;
			if (_month <= 0 || _month > 12)
			{
				_month=1;
			}
			_temp=_temp % 100;
			var _day:int=_temp;
			if (_day <= 0 || _day > 31)
			{
				_day=1;
			}
			var _ret:Date=new Date(_year, (_month - 1), _day);
			return _ret;
		}

		/**
		 * 格式20120101  转化成 字符串日期
		 * @param iDate
		 * @return
		 *
		 */
		public static function iDataToDateString(iDate:int, isEn:Boolean=false):String
		{
			var _date:Date=iDateToDate(iDate);
			var _iYear:int=_date.getFullYear();
			var _iMonth:int=_date.getMonth() + 1;
			var _iDate:int=_date.getDate();
			var _ret:String="";
			if (isEn)
			{
				_ret=_iYear + ":" + _iMonth + ":" + _iDate;
			}
			else
			{
				_ret=_iYear + Lang.getLabel("pub_nian") + _iMonth + Lang.getLabel("pub_yue") + _iDate + Lang.getLabel("pub_ri");
			}
			return _ret;
		}

		/**
		 * date  转化成 字符串日期：年 月 日
		 * @param iDate
		 * @return
		 *
		 */
		public static function dateToDateString(iDate:Date, isEn:Boolean=false):String
		{
			var _iYear:int=iDate.getFullYear();
			var _iMonth:int=iDate.getMonth() + 1;
			var _iDate:int=iDate.getDate();
			var _ret:String="";
			if (isEn)
			{
				_ret=_iYear + ":" + _iMonth + ":" + _iDate;
			}
			else
			{
				_ret=_iYear + Lang.getLabel("pub_nian") + _iMonth + Lang.getLabel("pub_yue") + _iDate + Lang.getLabel("pub_ri");
			}
			return _ret;
		}

		/**
		 * 判断一个字符串的长度  英文字符 计数为 1 个，中文字符计数 为 2个
		 * @param s
		 * @return
		 *
		 */
		public static function getStringLengthByChar(str:String):int
		{
			var _num:int;
			if (null == str)
			{
				return 0;
			}
			var _length:int=str.length;
			var _charNum:Number=0;
			for (var i:int=0; i < _length; ++i)
			{
				_charNum=str.charCodeAt(i);
				if (_charNum <= 128)
				{
					_num+=1;
				}
				else
				{
					_num+=2;
				}
			}
			return _num;
		}

		/**
		 *	放到粘贴板
		 *  @author andy 2012-09-21
		 */
		public static function copyFont(font:String=""):void
		{
			if (font == null)
				return;
			System.setClipboard(font);
		}

		/**
		 * 将一个字符串格式的时间转化成一个 时间对象
		 * @param time
		 * @return
		 *
		 */
		public static function changeStringTimeToDate(time:String):Date
		{
			var _year:int;
			var _month:int;
			var _date:int;
			var _arr:Array=time.split("-");
			_year=_arr[0];
			_month=_arr[1];
			_date=_arr[2];
			var _ret:Date=new Date(_year, _month - 1, _date);
			//var _ret:Date = new Date();
			///_ret.setUTCFullYear(1970,0,1);
			//_ret.setUTCHours(0,0,0,0);
						return _ret;
		}

		/**
		 * changeStringTimeToDate增强版， 支持YYMMDDhhmm
		 */
		public static function changeStringTimeToDate2(time:String):Date
		{
			var _year:int;
			var _month:int;
			var _day:int;
			var _hours:int;
			var _min:int;
			var _arr:Array=time.split("-");
			_year=_arr[0];
			_month=_arr[1];
			_day=_arr[2];
			_hours=_arr[3];
			_min=_arr[4];
			var _ret:Date=new Date(_year, _month - 1, _day, _hours, _min);
			//var _ret:Date = new Date();
			///_ret.setUTCFullYear(1970,0,1);
			//_ret.setUTCHours(0,0,0,0);
						return _ret;
		}

		/**
		 * 将一个数字处理成“万”。  如果该数值大于等于10000 的时候处理，如果小于 直接返回；
		 * @param num
		 * @return
		 *
		 */
		public static function changeToTenThousand(num:int):String
		{
			var _ret:String="";
			if (num >= 10000)
			{
				num=num / 10000;
				_ret+=num;
				_ret+=Lang.getLabel("pub_wan");
			}
			else
			{
				_ret+=num;
			}
			return _ret;
		}

		/**
		 * 根据当前的波数计算奖励公式，返回显示可用的字符串。
		 *
		 *
		 *
		 * @param index         四神器 副本的索引
		 * @param level         奖励的等级
		 * @return
		 *
		 */
		public static function smartImplementCountReward(index:int, level:int):String
		{
			var _ret:String="";
			var _arrWord:Array=Lang.getLabelArr("arrFourShenQi");
			var _i:int;
			switch (index)
			{
				case 0:
					//1 - 10
//					玄黄<挑战1>
//					雷电抗性 10+[(层数-1)^2.5]*0.25
//					生命 100+[(层数-1)^2.5]*5
//					闪避 50+[(层数-1)^2.5]*3
//					11 - 100
//					玄黄<挑战1>
//					雷电抗性 100+[(层数-1)^2]*0.25
//					生命 1000+[(层数-1)^2]*5
//					闪避 500+[(层数-1)^2]*3
					if (level >= 1 && level <= 10)
					{
						_ret+=_arrWord[2] + "<font color='#00ff00'>";
						_i=10 + (Math.pow((level - 1), 2.5) * 0.25);
						_ret+=_i + "</font>" + _arrWord[0] + "<br>";
						_ret+=_arrWord[3] + "<font color='#00ff00'>";
						_i=100 + (Math.pow((level - 1), 2.5) * 5);
						_ret+=_i + "</font>" + _arrWord[0] + "<br>";
						_ret+=_arrWord[4] + "<font color='#00ff00'>";
						_i=50 + (Math.pow((level - 1), 2.5) * 3);
						_ret+=_i + "</font>" + _arrWord[0];
					}
					else if (level >= 11 && level <= 100)
					{
						_ret+=_arrWord[2] + "<font color='#00ff00'>";
						_i=100 + (Math.pow((level - 1), 2) * 0.25);
						_ret+=_i + "</font>" + _arrWord[0] + "<br>";
						_ret+=_arrWord[3] + "<font color='#00ff00'>";
						_i=1000 + (Math.pow((level - 1), 2) * 5);
						_ret+=_i + "</font>" + _arrWord[0] + "<br>";
						_ret+=_arrWord[4] + "<font color='#00ff00'>";
						_i=500 + (Math.pow((level - 1), 2) * 3);
						_ret+=_i + "</font>" + _arrWord[0];
					}
					break;
				case 1:
//					1 - 10
//					冰荒<挑战2>
//					冰冻抗性 10+[(层数-1)^2.5]*0.25
//					生命 100+[(层数-1)^2.5]*5
//					攻击 10+[(层数-1)^2.5]*0.5
//					11 - 100
//					冰荒<挑战2>
//					冰冻抗性 100+[(层数-1)^2]*0.25
//					生命 1000+[(层数-1)^2]*5
//					攻击 100+[(层数-1)^2]*0.5
					if (level >= 1 && level <= 10)
					{
						_ret+=_arrWord[5] + "<font color='#00ff00'>";
						_i=10 + (Math.pow((level - 1), 2.5) * 0.25);
						_ret+=_i + "</font>" + _arrWord[0] + "<br>";
						_ret+=_arrWord[3] + "<font color='#00ff00'>";
						_i=100 + (Math.pow((level - 1), 2.5) * 5);
						_ret+=_i + "</font>" + _arrWord[0] + "<br>";
						_ret+=_arrWord[6] + "<font color='#00ff00'>";
						_i=10 + (Math.pow((level - 1), 2.5) * 0.5);
						_ret+=_i + "</font>" + _arrWord[0];
					}
					else if (level >= 11 && level <= 100)
					{
						_ret+=_arrWord[5] + "<font color='#00ff00'>";
						_i=100 + (Math.pow((level - 1), 2) * 0.25);
						_ret+=_i + "</font>" + _arrWord[0] + "<br>";
						_ret+=_arrWord[3] + "<font color='#00ff00'>";
						_i=1000 + (Math.pow((level - 1), 2) * 5);
						_ret+=_i + "</font>" + _arrWord[0] + "<br>";
						_ret+=_arrWord[6] + "<font color='#00ff00'>";
						_i=100 + (Math.pow((level - 1), 2) * 0.5);
						_ret+=_i + "</font>" + _arrWord[0];
					}
					break;
				case 2:
//					1 - 10
//					九狱<挑战3>
//					火焰抗性 10+[(层数-1)^2.5]*0.25
//					生命 100+[(层数-1)^2.5]*5
//					暴击 80+[(层数-1)^2.5]*3
//					
//					11 - 100
//					九狱<挑战3>
//					火焰抗性 100+[(层数-1)^2]*0.25
//					生命 1000+[(层数-1)^2]*5
//					暴击 800+[(层数-1)^2]*3
					if (level >= 1 && level <= 10)
					{
						_ret+=_arrWord[7] + "<font color='#00ff00'>";
						_i=10 + (Math.pow((level - 1), 2.5) * 0.25);
						_ret+=_i + "</font>" + _arrWord[0] + "<br>";
						_ret+=_arrWord[3] + "<font color='#00ff00'>";
						_i=100 + (Math.pow((level - 1), 2.5) * 5);
						_ret+=_i + "</font>" + _arrWord[0] + "<br>";
						_ret+=_arrWord[8] + "<font color='#00ff00'>";
						_i=80 + (Math.pow((level - 1), 2.5) * 3);
						_ret+=_i + "</font>" + _arrWord[0];
					}
					else if (level >= 11 && level <= 100)
					{
						_ret+=_arrWord[7] + "<font color='#00ff00'>";
						_i=100 + (Math.pow((level - 1), 2) * 0.25);
						_ret+=_i + "</font>" + _arrWord[0] + "<br>";
						_ret+=_arrWord[3] + "<font color='#00ff00'>";
						_i=1000 + (Math.pow((level - 1), 2) * 5);
						_ret+=_i + "</font>" + _arrWord[0] + "<br>";
						_ret+=_arrWord[8] + "<font color='#00ff00'>";
						_i=800 + (Math.pow((level - 1), 2) * 3);
						_ret+=_i + "</font>" + _arrWord[0];
					}
					break;
				case 3:
//					1-10层
//
//					长天<挑战4>
//					毒素抗性 10+[(层数-1)^2.5]*0.25
//					生命 100+[(层数-1)^2.5]*5
//					防御 40+[(层数-1)^2.5]*2
//					
//					11-100层
//					
//					长天<挑战4>
//					毒素抗性 100+[(层数-1)^2]*0.25
//					生命 1000+[(层数-1)^2]*5
//					防御 400+[(层数-1)^2]*2
					if (level >= 1 && level <= 10)
					{
						_ret+=_arrWord[9] + "<font color='#00ff00'>";
						_i=10 + (Math.pow((level - 1), 2.5) * 0.25);
						_ret+=_i + "</font>" + _arrWord[0] + "<br>";
						_ret+=_arrWord[3] + "<font color='#00ff00'>";
						_i=100 + (Math.pow((level - 1), 2.5) * 5);
						_ret+=_i + "</font>" + _arrWord[0] + "<br>";
						_ret+=_arrWord[10] + "<font color='#00ff00'>";
						_i=40 + (Math.pow((level - 1), 2.5) * 2);
						_ret+=_i + "</font>" + _arrWord[0];
					}
					else if (level >= 11 && level <= 100)
					{
						_ret+=_arrWord[9] + "<font color='#00ff00'>";
						_i=100 + (Math.pow((level - 1), 2) * 0.25);
						_ret+=_i + "</font>" + _arrWord[0] + "<br>";
						_ret+=_arrWord[3] + "<font color='#00ff00'>";
						_i=1000 + (Math.pow((level - 1), 2) * 5);
						_ret+=_i + "</font>" + _arrWord[0] + "<br>";
						_ret+=_arrWord[10] + "<font color='#00ff00'>";
						_i=400 + (Math.pow((level - 1), 2) * 2);
						_ret+=_i + "</font>" + _arrWord[0];
					}
					break;
				default:
					break;
			}
						return _ret;
		}
		/**
		 * 根据当前的波数计算奖励公式，返回显示可用的字符串。
		 *
		 *
		 * andy 2012－08－23
		 * @param index         四神器 副本的索引
		 * @param level         奖励的等级
		 * @return
		 *
		 */
		private static var arrAtt:Array=[[21, 1, 8], [19, 1, 5], [18, 1, 9], [20, 1, 6]];

		public static function smartImplementCountReward2(vecLevel:Vector.<int>):Vector.<StructItemAttr2>
		{
			var _ret:Vector.<StructItemAttr2>=new Vector.<StructItemAttr2>;
			var level:int=0;
			var att:StructItemAttr2=null;
			for (var i:int=0; i < vecLevel.length; i++)
			{
				level=vecLevel[i];
				switch (i)
				{
					case 0:
						if (level >= 1 && level <= 10)
						{
							att=getAtt(arrAtt[i][0], _ret);
							att.attrValue+=10 + (Math.pow((level - 1), 2.5) * 0.25);
							att=getAtt(arrAtt[i][1], _ret);
							att.attrValue+=100 + (Math.pow((level - 1), 2.5) * 5);
							att=getAtt(arrAtt[i][2], _ret);
							att.attrValue+=50 + (Math.pow((level - 1), 2.5) * 3);
						}
						else if (level >= 11 && level <= 100)
						{
							att=getAtt(arrAtt[i][0], _ret);
							att.attrValue+=100 + (Math.pow((level - 1), 2) * 0.25);
							att=getAtt(arrAtt[i][1], _ret);
							att.attrValue+=1000 + (Math.pow((level - 1), 2) * 5);
							att=getAtt(arrAtt[i][2], _ret);
							att.attrValue+=500 + (Math.pow((level - 1), 2) * 3);
						}
						break;
					case 1:
						if (level >= 1 && level <= 10)
						{
							att=getAtt(arrAtt[i][0], _ret);
							att.attrValue+=10 + (Math.pow((level - 1), 2.5) * 0.25);
							att=getAtt(arrAtt[i][0], _ret);
							att.attrValue+=100 + (Math.pow((level - 1), 2.5) * 5);
							att=getAtt(arrAtt[i][0], _ret);
							att.attrValue+=10 + (Math.pow((level - 1), 2.5) * 0.5);
						}
						else if (level >= 11 && level <= 100)
						{
							att=getAtt(arrAtt[i][0], _ret);
							att.attrValue+=100 + (Math.pow((level - 1), 2) * 0.25);
							att=getAtt(arrAtt[i][1], _ret);
							att.attrValue+=1000 + (Math.pow((level - 1), 2) * 5);
							att=getAtt(arrAtt[i][2], _ret);
							att.attrValue+=100 + (Math.pow((level - 1), 2) * 0.5);
						}
						break;
					case 2:
						if (level >= 1 && level <= 10)
						{
							att=getAtt(arrAtt[i][0], _ret);
							att.attrValue+=10 + (Math.pow((level - 1), 2.5) * 0.25);
							att=getAtt(arrAtt[i][1], _ret);
							att.attrValue+=100 + (Math.pow((level - 1), 2.5) * 5);
							att=getAtt(arrAtt[i][2], _ret);
							att.attrValue+=80 + (Math.pow((level - 1), 2.5) * 3);
						}
						else if (level >= 11 && level <= 100)
						{
							att=getAtt(arrAtt[i][0], _ret);
							att.attrValue+=100 + (Math.pow((level - 1), 2) * 0.25);
							att=getAtt(arrAtt[i][1], _ret);
							att.attrValue+=1000 + (Math.pow((level - 1), 2) * 5);
							att=getAtt(arrAtt[i][2], _ret);
							att.attrValue+=800 + (Math.pow((level - 1), 2) * 3);
						}
						break;
					case 3:
						if (level >= 1 && level <= 10)
						{
							att=getAtt(arrAtt[i][0], _ret);
							att.attrValue+=10 + (Math.pow((level - 1), 2.5) * 0.25);
							att=getAtt(arrAtt[i][1], _ret);
							att.attrValue+=100 + (Math.pow((level - 1), 2.5) * 5);
							att=getAtt(arrAtt[i][2], _ret);
							att.attrValue+=40 + (Math.pow((level - 1), 2.5) * 2);
						}
						else if (level >= 11 && level <= 100)
						{
							att=getAtt(arrAtt[i][0], _ret);
							att.attrValue+=100 + (Math.pow((level - 1), 2) * 0.25);
							att=getAtt(arrAtt[i][1], _ret);
							att.attrValue+=1000 + (Math.pow((level - 1), 2) * 5);
							att=getAtt(arrAtt[i][2], _ret);
							att.attrValue+=400 + (Math.pow((level - 1), 2) * 2);
						}
						break;
					default:
						break;
				}
			}
			return _ret;
		}

		private static function getAtt(attId:int, vec:Vector.<StructItemAttr2>):StructItemAttr2
		{
			var att:StructItemAttr2;
			for each (var item:StructItemAttr2 in vec)
			{
				if (item.attrIndex == attId)
				{
					att=item;
					break;
				}
			}
			if (att == null)
			{
				att=new StructItemAttr2();
				att.attrIndex=attId;
				vec.push(att);
			}
			return att;
		}

//		【玄黄大陆】 #72f9b2   
//		【冰荒大陆】 #9af9ef
//		【九幽大陆】 #72f9d1
//		【绝世魔王】 #f88a5f
//		【历史古迹】 #fdffce
//		【灵器仙宝】 #f8bbfd
//		【鬼斧神兵】 #72f9d1
//		【创世神器】 #a5edf8
//		【三界仙术】 #fdf86f
//		【英雄伙伴】 #f9d872
//		【神兽坐骑】 #72f9b2
//		【天地神仙】 #9af9ef
		public static function collectCardSuitColor(suitID:int):String
		{
			var _ret:String="#fff5d2";
			switch (suitID)
			{
				case 101:
					_ret="#72f9b2";
					break;
				case 102:
					_ret="#9af9ef";
					break;
				case 103:
					_ret="#f88a5f";
					break;
				case 104:
					_ret="#fdffce";
					break;
				case 105:
					_ret="#f8bbfd";
					break;
				case 106:
					_ret="#72f9d1";
					break;
				case 107:
					_ret="#a5edf8";
					break;
				case 108:
					_ret="#9af9ef";
					break;
				case 109:
					_ret="#fdf86f";
					break;
				case 110:
					_ret="#f9d872";
					break;
				case 111:
					_ret="#72f9b2";
					break;
				case 112:
					_ret="#72f9d1";
					break;
				case 113:
					break;
				default:
					break;
			}
			return _ret;
		}

		/**
		 * 获得开服第几天
		 * @return
		 *
		 */
		public static function diJiTian():int
		{
			//
			var oldDateStr:String=GameIni.starServerTime();
			var oldDate:Date=StringUtils.changeStringTimeToDate(oldDateStr);
			//
			var nowDate:Date=Data.date.nowDate;
			nowDate.hours=0;
			nowDate.minutes=0;
			nowDate.seconds=0;
			nowDate.milliseconds=0;
			var days:Number=(nowDate.time - oldDate.time) / 1000 / 60 / 60 / 24;
			/*MsgPrint.printTrace("oldDate:" + oldDateStr +
			" nowDate" + nowDate.toString() +
			" days:" + days.toString(),MsgPrintType.WINDOW_REFRESH);*/
			return days + 1;
		}

		/**
		 * 获得自定义开服第几天
		 * @return
		 *
		 */
		public static function diJiTian2(startdate:int):int
		{
			//
			//var oldDateStr:String = GameIni.starServerTime();			
			var oldDate:Date=StringUtils.iDateToDate(startdate);
			//
			var nowDate:Date=Data.date.nowDate;
			//nowDate.hours = 0;
			//nowDate.minutes = 0;
			//nowDate.seconds = 0;
			//nowDate.milliseconds = 0;
			var days:Number=(nowDate.time - oldDate.time) / 1000 / 60 / 60 / 24;
			var days_:int=Math.round(days);
			/*MsgPrint.printTrace("oldDate:" + oldDateStr +
			" nowDate" + nowDate.toString() +
			" days:" + days.toString(),MsgPrintType.WINDOW_REFRESH);*/
			return days_ + 1;
		}

		public static function diJiTianByDiff(totalDay:int=7):Array
		{
			//
			var oldDateStr:String=GameIni.starServerTime();
			var oldDate:Date=StringUtils.changeStringTimeToDate(oldDateStr);
			//
			var nowDate:Date=Data.date.nowDate;
			//
			var diff:Number=nowDate.time - oldDate.time;
			// / 1000 / 60 / 60 / 24
						//floor 下限值
			var days:int=Math.floor(diff / 1000 / 60 / 60 / 24);
			//因是下限值，有可能为0
			days++;
			//
			diff=diff % (1000 * 60 * 60 * 24);
			var hous:int=Math.floor(diff / 1000 / 60 / 60);
			hous++;
			//
			diff=diff % (1000 * 60 * 60);
			var mins:int=Math.floor(diff / 1000 / 60);
			mins++;
			diff=diff % (1000 * 60);
			//
			var seconds:int=Math.floor(diff / 1000);
			seconds++;
			return [totalDay - days, 24 - hous, 60 - mins, 60 - seconds];
		}

		public static function dateByDiff(date1:Date, date2:Date):Array
		{
			//
			var diff:Number=Math.abs(date1.time - date2.time);
			// / 1000 / 60 / 60 / 24
						//floor 下限值
			var days:int=Math.floor(diff / 1000 / 60 / 60 / 24);
			//因是下限值，有可能为0
			//days++;
			//
			diff=diff % (1000 * 60 * 60 * 24);
			var hous:int=Math.floor(diff / 1000 / 60 / 60);
			//hous++;
			//
			diff=diff % (1000 * 60 * 60);
			var mins:int=Math.floor(diff / 1000 / 60);
			//mins++;
			diff=diff % (1000 * 60);
			//
			var seconds:int=Math.floor(diff / 1000);
			//seconds++;
			return [days, hous, mins, seconds];
		}

		/**
		 * 在当前时间上添加一个天数
		 * @param cDate             当前时间
		 * @param dayNum            添加天数
		 * @return
		 *
		 */
		public static function addDay(cDate:Date, dayNum:int):Date
		{
			var _cDateTime:Number=cDate.getTime();
			var _dayTime:Number=dayNum * 60 * 60 * 24 * 1000;
			var _retTime:Number=_cDateTime + _dayTime;
			var _ret:Date=new Date();
			_ret.setTime(_retTime);
			return _ret;
		}

		/**
		 * 将阿拉伯数字换成中文
		 * @param num
		 * @return
		 *
		 */
		public static function changeToZH(num:int):String
		{
			var _ret:String="十一";
			switch (num)
			{
				case 1:
					_ret="一";
					break;
				case 2:
					_ret="二";
					break;
				case 3:
					_ret="三";
					break;
				case 4:
					_ret="四";
					break;
				case 5:
					_ret="五";
					break;
				case 6:
					_ret="六";
					break;
				case 7:
					_ret="七";
					break;
				case 8:
					_ret="八";
					break;
				case 9:
					_ret="九";
					break;
				case 10:
					_ret="十";
					break;
				default:
					break;
			}
			return _ret;
		}
		public static const JI_SHU:int=1;
		public static const OU_SHU:int=0;

		public static function isJiOu(num:int):int
		{
			return num % 2;
		}

		/**
		 * 创建一个随机整数
		 * @param iMax
		 * @return
		 *
		 */
		public static function createIntRandom(iMax:int):int
		{
			return int(iMax * Math.random());
		}
	}
}
