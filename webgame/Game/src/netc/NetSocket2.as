package netc
{
	import avmplus.getQualifiedClassName;
	
	import common.config.GameIni;
	import common.managers.Lang;
	import common.utils.AsToJs;
	
	import engine.load.GamelibS;
	import engine.net.packet.PacketFactory;
	import engine.support.IPacket;
	import engine.utils.Debug;
	
	import flash.errors.EOFError;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.Socket;
	import flash.system.Security;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import netc.process.ProcessRegister;
	
	import nets.packets.PacketRegister;
	import nets.packets.PacketSCHeart;
	
	import ui.view.view6.GameAlert;
	
	import world.WorldDispatcher;
	import world.WorldEvent;

	public class NetSocket2
	{
		private var _socket:Socket;

		private var bytes:ByteArray;


//		private var timer:Timer;

		private var userClose:Boolean=false;
		public static const HITS:int=20;


		private var PingTime:int=0;

		private var HeartRecvs:Boolean=true;

		private var SN:int=1;

		public var SEND:int=0;
		public var RECV:int=0;

		// 解密器
//		private var RecvEncryptor:EncryptPacket=new EncryptPacket();
		// 加密器
//		private var SendEncryptor:EncryptPacket=new EncryptPacket();

		//加解密器开关
//		public const isEncry:Boolean=false;

		public function NetSocket2(target:IEventDispatcher=null):void
		{
			//注册
			new PacketRegister();
			new ProcessRegister();

			bytes=new ByteArray();
			bytes.endian=Endian.LITTLE_ENDIAN;

//			timer=new Timer(GameIni.packageSleep == 0 ? 50 : GameIni.packageSleep, 1);
			if (GameIni.packageRun == 0)
			{
				GameIni.packageRun=200;
			}
			//
			addScoketEvent();
//			timer.addEventListener(TimerEvent.TIMER, timerHandler);
//			UpdateToServer.instance;
		}

		/*
		 * 断开连接
		 */

		public function set socket(value:Socket):void
		{
			_socket=value;
		}

		public function get socket():Socket
		{
			return _socket;
		}

		public function disConnect():void
		{
			userClose=true;
			socket.close();
		}

		/*
		 * 选线重连
		 */
		public function reConnect():void
		{
			userClose=false;
			Debug.instance.traceMsg("连接服务器:" + GameIni.CONNECT_IP + " 端口:" + GameIni.CONNECT_PORT);
			socket.connect(GameIni.CONNECT_IP, GameIni.CONNECT_PORT);

//			MsgPrint.printTrace("连接服务器:" + GameIni.CONNECT_IP + " 端口:" + GameIni.CONNECT_PORT, MsgPrintType.SOCKET_CONNECT);
		}

		/**
		 * SOCKET发送数据統一調用方法
		 *
		 */
		private var sendTime:int;

		//private var sendCount:int=0;
		//private var sendInfo:String="";

		public function send(pack:IPacket):void
		{
			if (socket.connected)
			{
				sendTime=getTimer();
				if (MsgPrint.printOpen)
				{
					MsgPrint.printTraceByPacket(pack, MsgPrintType.SOCKET_SEND);
				}
				var byteArray:ByteArray=new ByteArray();
				byteArray.endian="littleEndian";
				pack.Serialize(byteArray);
				var temArray:ByteArray=new ByteArray();
				temArray.endian="littleEndian";
				temArray.writeInt(byteArray.length + 4);
				temArray.writeShort(PacketVersion.packet_version);
				temArray.writeShort(SN);
				temArray.writeBytes(byteArray);
				socket.writeBytes(temArray);
				//newcodes
				byteArray.clear();
				byteArray=null;
				temArray.clear();
				temArray=null;
				SN++;
				if (SN > 10000)
					SN=1;
				SEND++;
//				if (MsgPrint.printOpen)
//				{
//					MsgPrint.printSendNum(SEND);
//				}
				socket.flush();
			}
			else
			{
				trace("连接已中断");
			}
		}

		public function addScoketEvent():void
		{
			socket=new Socket();
			socket.endian="littleEndian";
			socket.addEventListener(Event.CLOSE, closeHandler);
			socket.addEventListener(Event.CONNECT, connectHandler);
			socket.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			socket.addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
		}

		public function Connect():void
		{
			if (!socket.connected)
			{
				Security.loadPolicyFile("xmlsocket://" + GameIni.CONNECT_IP + ":843");

				Debug.instance.traceMsg("连接服务器:" + GameIni.CONNECT_IP + " 端口:" + GameIni.CONNECT_PORT);
				socket.connect(GameIni.CONNECT_IP, GameIni.CONNECT_PORT);

			}
			else
			{
				Debug.instance.traceMsg("已经与服务器连接");
			}
		}

		private function closeHandler(e:Event):void
		{
			MsgPrint.printTrace("服务连接断开:" + e.type, MsgPrintType.SOCKET_CONNECT);

			//WorldDispatcher.instance.dispatchEvent(new WorldEvent(WorldDispatcher.TXT_INFO, "与服务器连接断开连接"));

			WorldDispatcher.instance.dispatchEvent(new WorldEvent(WorldDispatcher.TXT_INFO, Lang.getLabel("50009_NetSocket2")));

			if (!userClose)
			{
				DispatEventSocketMsg("\n与服务器连接断开连接");
			}
		}

		private function connectHandler(e:Event):void
		{
			if (e != null)
			{
				//Debug.instance.traceMsg("服务连接成功:" + e.type);

				MsgPrint.printTrace("连接成功" + e.type, MsgPrintType.SOCKET_CONNECT);
				//===========以下字符串是连接腾讯服务器必须的，连接其它服务器可以屏蔽掉
				var tgwStr:String="tgw_l7_forward\r\nHost: " + GameIni.CONNECT_IP + ":" + GameIni.CONNECT_PORT + "\r\n\r\n";
				socket.writeMultiByte(tgwStr, "GBK");
				socket.flush();
			}
		}

		private function ioErrorHandler(e:IOErrorEvent):void
		{
			//Longin.instance.parent.removeChild(Longin.instance);
			MsgPrint.printTrace("数据IO错误:" + e.type + " 消息:" + e.text, MsgPrintType.SOCKET_CONNECT);

			DispatEventSocketMsg("数据IO错误:" + e.type + " 消息:" + e.text);
		}

		private function securityErrorHandler(e:SecurityErrorEvent):void
		{
			MsgPrint.printTrace("安全访问受限：" + e.type + " 消息:" + e.text, MsgPrintType.SOCKET_CONNECT);

			DispatEventSocketMsg("安全访问受限：" + e.type + " 消息:" + e.text);
		}

		// ######################################################################
		private function timerHandler(e:TimerEvent=null):void
		{
			dListener();

//			var monitorOpen:Boolean = GameIni.MonitorOpen;
//			
//			if(monitorOpen)
//			{
//				var len:int=packagesName.length;
//				for (var i:int=0; i < len; i++)
//				{
//					Monitor.instance.addInfo(packagesName[i], ["object", "act", "len", "Time", "fps", "Memory", "RomanceNum", "MovieNum", "MovieLoaded"], [packagesName[i], "收包", packagesLen[i], packagesTime[i], Stats.getInstance().refFPS, System.totalMemory * 0.00000095367431640625, MovieLoad.instance.playMovieCollect.length, MovieLoad.instance.movieCollect.length, MovieLoad.instance.allLoadable.length]);
//				}
//				packagesName=[];
//				packagesLen=[];
//				packagesTime=[];
//			}
//			
//			if (bytes.bytesAvailable > 0)
//			{
//				timer.start();
//			}
		}

		private function socketDataHandler(e:ProgressEvent):void
		{
//			if (bytes.bytesAvailable == 0)
//			{
//				bytes=new ByteArray();
//				bytes.endian=Endian.LITTLE_ENDIAN;
//
//			}
			socket.readBytes(bytes, bytes.length);
//			timer.start();
			dListener();
//			if(SceneManager.instance.isDeactivate)
//			{
//				timerHandler();
//			}

		}

		// ######################################################################


		// ######################################################################
		/**
		 * 连接是否中断
		 */
		public function get connected():Boolean
		{
			return socket.connected;
		}

//		private var bRecv:ByteArray=new ByteArray();
		private var packagesName:Array=[];
		private var packagesLen:Array=[];
		private var packagesTime:Array=[];
		private var onePackageName:String;
		private var onePackageTime:int=0;
		private var runMark:int;

		public function dListener():void
		{
			runMark=getTimer();
			while (bytes.bytesAvailable > 4)
			{
//				if (getTimer() - runMark > GameIni.packageRun)
//				{
//					timer.start();
//				}
				onePackageTime=getTimer();
				onePackageName=null;
				var len:int=bytes.readInt();
				if (bytes.bytesAvailable >= len)
				{
					var pos:int=bytes.position;
					// 版本和序列号
					var version_sn:int=bytes.readInt();
					// 包标示ID
					var packID:int=bytes.readInt();
//					try
//					{
//					if (MsgPrint.printOpen)
//					{
//						MsgPrint.printTrace("解析中:   " + packID.toString(), MsgPrintType.SOCKET_RECV);
//					}
					// 包数据长度
					var packDataLen:int=len - (bytes.position - pos);
					// 预期包的结束位置
					var expectPackEndPos:int=bytes.position + packDataLen;
					var pack:IPacket=PacketFactory.Instance.CreatePacket(packID);
					RECV++;

//					if (MsgPrint.printOpen)
//					{
//						MsgPrint.printRecvNum(RECV);
//					}

					if (pack == null)
					{
						// 略过当前未知的包
						bytes.position=expectPackEndPos;
						continue;
					}
					var bException:Boolean=false;
					try
					{
						pack.Deserialize(bytes);
					}
					catch (eEof:EOFError)
					{
						bException=true;
						MsgPrint.printTrace("Packet " + packID.toString() + " Deserialize Exception\r\n" + eEof.message + eEof.getStackTrace(), MsgPrintType.SOCKET_RECV);
					}
					finally
					{
						// 当前包的位置确保
						bytes.position=expectPackEndPos;
						if (MsgPrint.printOpen)
						{
							MsgPrint.printTraceByPacket(pack, MsgPrintType.SOCKET_RECV);
						}
					}
					// 反序列化异常(可能是协议不匹配了)
					if (bException)
					{
						continue;
					}

					if (pack.GetId() != PacketSCHeart.id)
					{
						DataKey.instance.receive(pack);

						if (MsgPrint.printOpen)
						{
							onePackageName=getQualifiedClassName(pack);
						}
					}

//					}
//					catch (exc:Error)
//					{
//						//这个地方要强制输出
//					}
				}
				else
				{
					bytes.position=bytes.position - 4;
					break;
				}
			}
			if (bytes.bytesAvailable == 0)
			{
				bytes.clear();
			}
		}

		// 断开重连
		private var breakTimer:Timer=new Timer(5000, 1);

		public function DispatEventSocketMsg(msg:String):void
		{
			if (!breakTimer.hasEventListener(TimerEvent.TIMER))
				breakTimer.addEventListener(TimerEvent.TIMER, breakTimerHandler);
			if (!breakTimer.running)
				breakTimer.start();
		}

		private function breakTimerHandler(e:TimerEvent=null):void
		{
//			socket.addEventListener(Event.CONNECT, connectHandler2);
//			socket.connect(GameIni.CONNECT_IP, GameIni.CONNECT_PORT);
			connectHandler2();
			breakTimer.removeEventListener(TimerEvent.TIMER, breakTimerHandler);
		}

		private function connectHandler2(e:Event=null):void
		{
			(new GameAlert).ShowMsg(GamelibS.getswflink("game_login", "win_chonglian"), 3, null, function():void
			{
				AsToJs.callJS("refreshpage");
			});

			WorldDispatcher.instance.dispatchEvent(new WorldEvent(WorldDispatcher.CHONGLIAN));
		}

	}
}
