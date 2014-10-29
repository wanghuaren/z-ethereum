package netc
{
	import com.demonsters.debugger.MonsterDebugger;
	
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	
	import flash.display.DisplayObject;

	public class MsgPrint
	{
		public static var printOpen:Boolean=false;

		private static var _data:Vector.<String>=new Vector.<String>();

		private static var _filter:String="none";

		private static var _panel:DisplayObject;

		/**
		 * debug面板显示用
		 *
		 * 仅显示
		 * 2为默认不显示
		 *
		 */
		private static var _filterPacketNameList:Array;
		private static var _filterPacketNameList2:Array;

		public static const CLASS_NAME_CH:String="类名:";

		public static var showStopPoint:Boolean=false;

		public static function get filterPacketNameList2():Array
		{
			if (null == _filterPacketNameList2)
			{
				_filterPacketNameList2=new Array();
				_filterPacketNameList2.push("解析中");
				_filterPacketNameList2.push("PacketSCMove");
				_filterPacketNameList2.push("PacketSCPlayerMove");
				_filterPacketNameList2.push("PacketSCMoveStop");
				_filterPacketNameList2.push("PacketSCObjLeaveGrid");
				_filterPacketNameList2.push("PacketSCMonsterEnterGrid");
				_filterPacketNameList2.push("PacketSCHeart");

				//_filterPacketNameList2.push("PacketCSSysHeart");
				_filterPacketNameList2.push("PacketCSPlayerCurPos");

			}

			return _filterPacketNameList2;
		}

		public static function set filterPacketNameList2(value:Array):void
		{
			_filterPacketNameList2=value;
		}

		public static function get filterPacketNameList():Array
		{
			if (null == _filterPacketNameList)
			{
				_filterPacketNameList=new Array();
					//_filterPacketNameList.push(CLASS_NAME_CH + "PacketSCMove");
					//_filterPacketNameList.push(CLASS_NAME_CH + "PacketSCMoveStop");



			}

			return _filterPacketNameList;
		}

		public static function set filterPacketNameList(value:Array):void
		{
			_filterPacketNameList=value;
		}

		/**
		 * 前台debug面板
		 */
		public static function get panel():DisplayObject
		{
			return _panel;
		}

		public static function set panel(value:DisplayObject):void
		{
			_panel=value;
		}

		public static function filterPacketNameListToObj():Array
		{

			var i:int;

			var len:int=filterPacketNameList.length;

			var objArr:Array=[];

			for (i=0; i < len; i++)
			{
				var o:Object={label: filterPacketNameList[i], data: i}

				objArr.push(o);

			}

			return objArr;

		}

		public static function filterPacketNameList2ToObj():Array
		{

			var i:int;

			var len:int=filterPacketNameList2.length;

			var objArr:Array=[];

			for (i=0; i < len; i++)
			{
				var o:Object={label: filterPacketNameList2[i], data: i}

				objArr.push(o);

			}

			return objArr;

		}

		public static function hasFilter(packetName:String):Boolean
		{
			var i:int;

			var len:int=filterPacketNameList.length;

			for (i=0; i < len; i++)
			{
				if (packetName.indexOf(filterPacketNameList[i]) == -1)
				{

				}
				else
				{
					return true;
				}

			}

			return false;

		}

		public static function hasFilter2(packetName:String):Boolean
		{
			var i:int;

			var len:int=filterPacketNameList2.length;

			for (i=0; i < len; i++)
			{
				if (packetName.indexOf(filterPacketNameList2[i]) == -1)
				{

				}
				else
				{
					return true;
				}

			}

			return false;

		}

		public static function isFilter2(line:String):Boolean
		{
			var i:int;

			var len:int=filterPacketNameList2.length;

			for (i=0; i < len; i++)
			{
				if (line.indexOf(filterPacketNameList2[i]) == -1)
				{

				}
				else
				{
					return true;
				}

			}

			return false;

		}




		public static function isFilter(line:String):Boolean
		{
			var i:int;

			var len:int=filterPacketNameList.length;

			for (i=0; i < len; i++)
			{
				if (line.indexOf(filterPacketNameList[i]) == -1)
				{

				}
				else
				{
					return true;
				}

			}

			return false;

		}

		public static function isSend(line:String):String
		{
			//filter
			if (line.indexOf(createSource(MsgPrintType.SOCKET_RECV)) == -1)
			{
				//

				return line;

			}

			//统计换行个数
			/*
				var rnPattern:RegExp = /\n/;
				var rnCount:int;

				while(line.indexOf("\n") != -1)
				{
					line = line.replace(rnPattern,"");

					rnCount++;
				}

				line = "";

				for(var i:int=0;i<rnCount;i++)
				{
					line += "\n";
				}


				return line;

			*/

			return "";
		}

		public static function isRecv(line:String):String
		{
			//filter
			if (line.indexOf(createSource(MsgPrintType.SOCKET_SEND)) == -1)
			{
				//

				return line;

			}

			//统计换行个数
			/*
				var rnPattern:RegExp = /\n/;
				var rnCount:int;

				while(line.indexOf("\n") != -1)
				{
					line = line.replace(rnPattern,"");

					rnCount++;
				}

				line = "";

				for(var i:int=0;i<rnCount;i++)
				{
					line += "\n";
				}

				return line;

			*/

			return "";

		}

		/**
		 *
		 */
		public static function printWindow():String
		{
			var line:String="";

			var len:int=_data.length;

			for (var i:int=0; i < len; i++)
			{
				//filter
				if (_data[i].indexOf(_filter) == -1)
				{
					//
					line+=_data[i];
				}
			}

			return line;
		}

		private static function createTimes():String
		{
			var dt:Date=new Date();

			//几号 dt.date.toString()
			return dt.hours.toString() + ":" + dt.minutes.toString() + ":" + dt.seconds.toString() + "." + dt.milliseconds.toString();
		}

		private static function createSource(source:String):String
		{
			var sourceCh:String="";

			switch (source)
			{
				case MsgPrintType.SOCKET_CONNECT:
					sourceCh="网络连接";
					break;

				case MsgPrintType.SOCKET_RECV:
					sourceCh="接收";
					break;

				case MsgPrintType.SOCKET_SEND:
					sourceCh="发送";
					break;

				case MsgPrintType.SOCKET_DATA_PROCESS:
					sourceCh="接收(process)";
					break;

				case MsgPrintType.WINDOW_REFRESH:
					sourceCh="发送(面板刷新)";
					break;

				case MsgPrintType.WINDOW_ERROR:
					sourceCh="发送(面板错误)";
					break;

				case MsgPrintType.TIMER_TICK:
					sourceCh="发送(定时器错误)";
					break;

				default:
					throw new Error("未定义来源 f:createSource c:MsgPrint");

			}


			return sourceCh;
		}

		private static function clear():void
		{
			//clear
			if (_data.length > 150)
			{
				for (var i:int=0; i < 30; i++)
				{
					_data.shift();
				}
			}

		}

		/**
		 *
		 */
		private function clearAll():void
		{
			var len:int=_data.length;

			for (var i:int=0; i < len; i++)
			{
				_data.pop();
			}
		}



		/**
		 * printTrace函数重载
		 */
		private static var _packHelp:PacketBaseProcess;

		public static function get packHelp():PacketBaseProcess
		{
			if (!_packHelp)
			{
				_packHelp=new PacketBaseProcess();
			}

			return _packHelp;
		}

		/**
		 * source 网络连接 socket
		 *             网络数据接收
		 */
		public static function printTrace(content:String, source:String):void
		{

			var value:String=createTimes();
//			var value:String="";

			//--
			source=createSource(source);

			//
			content+="\n";

			//
			source="[" + source + "]" + content;

			value+=source;

			//clear
			clear();

			//save
			_data.push(value);

			//
			if (null == MsgPrint.panel)
			{
				return;
			}

			MsgPrint.panel.dispatchEvent(new MsgEvent(MsgEvent.MSG_EVENT_DATA_REFRESH, false, false, value));
			MonsterDebugger.log(value);

//			//Debug.instance.traceMsg也是需要的
//			//Debug.instance.traceMsg(value);


		}



		public static function printTraceByPacket(pack:IPacket, source:String):void
		{
			var value:String=createTimes();
//			var value:String="";

			var o:Object=packHelp.helpByReflect(pack);

			var content:String="";

			//得到pack的名称
			var pack_name:String=packHelp.helpByReflext_PackName(pack);


			//			
			var beginStr:String="解析成功: " + pack.GetId().toString() + " " + "        " + CLASS_NAME_CH + pack_name + "\n";

			//beginStr += "[------------ begin ------------]\n"
			//beginStr += "\n";

			//var endStr:String    = "[------------ end ------------]\n";
			var endStr:String="\n";

			content+=packHelp.helpByO(o, beginStr, endStr);
			//--
			source=createSource(source);

			//
			source="[" + source + "]" + content;

			value+=source;

			//clear
			clear();

			//save
			_data.push(value);

			MsgPrint.panel.dispatchEvent(new MsgEvent(MsgEvent.MSG_EVENT_DATA_REFRESH, false, false, value));

			MonsterDebugger.log(value);
			//Debug.instance.traceMsg也是需要的
			//Debug.instance.traceMsg(value);


		}


//		public static function printSendNum(value:int):void
//		{
//
//			MsgPrint.panel.dispatchEvent(new MsgEvent(MsgEvent.MSG_EVENT_NUM_REFRESH, false, false, {"send": value.toString()}));
//			MonsterDebugger.log("send:"+value.toString());
//		}

//		public static function printRecvNum(value:int):void
//		{
//
//			MsgPrint.panel.dispatchEvent(new MsgEvent(MsgEvent.MSG_EVENT_NUM_REFRESH, false, false, {"recv": value.toString()}));
//			MonsterDebugger.log("recv:"+ value.toString());
//		}
	}
}
