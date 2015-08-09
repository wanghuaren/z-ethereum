package netc
{
	import com.engine.utils.Hash;
	
	import common.utils.clock.GameClock;
	
	import engine.net.func.FuncModel;
	import engine.support.IFunc;
	import engine.support.IPacket;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import netc.packets2.PacketSCVersion2;
	
	import nets.packets.*;
	
	import ui.base.login.Login;
	
	import world.WorldEvent;

	//[Event(name="cServerList", type="net.DataKeyEvent")]
	//public class DataKey extends EventDispatcher
	public class DataKey
	{
		/**
		 * 数据接收队列
		 */
		private var _cList:Vector.<IPacket>=new Vector.<IPacket>();
		/**
		 * 数据发送队列
		 */
		private var _sList:Vector.<IPacket>=new Vector.<IPacket>();
		/**
		 *
		 */
		private var _socket:NetSocket2=new NetSocket2();
		private var _heartTime:Timer;
		private var _sleep:Boolean=false;
		private var _sleepCurrentCount:int=0;
		public static const sleepMaxCount:int=160; //180;//
		//----------------------------------------------------------
		private var _playerEnterGridCount:int;
		private var _monsterEnterGridCount:int;
		private var _objLeaveGridCount:int;
		private var _sayMapCount:int;
		//----------------------------------------------------------
		public static const playerEnterGridMaxCount:int=1;
		public static const monsterEnterGridMaxCount:int=1;
		public static const objLeaveGridMaxCount:int=1;
		public static const sayMapMaxCount:int=2;

		//----------------------------------------------------------
		public function get heartTime():Timer
		{
			if (null == _heartTime)
			{
				_heartTime=new Timer(100);
			}
			return _heartTime;
		}

		public function get runCount():int
		{
			return _runCount;
		}

		/**
		 * 睡眠模式
		 */
		public function get sleep():Boolean
		{
			return _sleep;
		}

		public function set sleep(value:Boolean):void
		{
			_sleep=value;
		}

		public function connectHandler(e:Event):void
		{
			//需在登陆之前发
			var p2:PacketCSVersion=new PacketCSVersion();
			this.send(p2);
			Login.instance.readlyLogin2();
		}

		public function connect():void
		{
			this.register(PacketSCVersion.id, SCVersion);
			_socket.socket.addEventListener(Event.CONNECT, connectHandler);
			_socket.Connect();
			//
			//heartCount = 0;
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, RunCountHandler);
			GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND, RunCountHandler);
			heartTime.removeEventListener(TimerEvent.TIMER, HeartHandler);
			heartTime.addEventListener(TimerEvent.TIMER, HeartHandler);
			heartTime.reset();
			heartTime.start();
			//GameClock.instance.removeEventListener(WorldEvent.CLOCK__SECOND100, HeartHandler);
			//GameClock.instance.addEventListener(WorldEvent.CLOCK__SECOND100, HeartHandler);
		}

		public function connected():Boolean
		{
			return _socket.connected;
		}

		public function get socket():NetSocket2
		{
			return _socket;
		}
		private var _pushList:Hash=new Hash
		/**
		 * 经过packetProcess处理后的激活处理函数
		 * 此处存放的应是 上层逻辑处理函数
		 */
//		private var _fList:Vector.<IFunc>=new Vector.<IFunc>();
		/**
		 * 待删除列表
		 */
		private var _delList:Vector.<IFunc>=new Vector.<IFunc>();
		/**
		 *
		 */
		private static var _instance:DataKey;
		public var firstRecvPlayerData:Boolean=false;

		public static function get instance():DataKey
		{
			if (!_instance)
			{
				_instance=new DataKey();
			}
			return _instance;
		}

		public function DataKey()
		{
		}
		private var _ServerVersion:String="";

		public function get ServerVersion():String
		{
			return _ServerVersion;
		}

		public function SCVersion(p:PacketSCVersion2):void
		{
			_ServerVersion=p.version;
		}

		/**
		 * 最后一个参数弱引用，默认为true
		 */
		/*override public function  addEventListener(type:String,listener:Function,
												   useCapture:Boolean=false,
												   priority:int=0,
												   useWeakReference:Boolean=true):void
		{
			//最后一个参数弱引用，默认为true
			super.addEventListener(type,listener,useCapture,priority,useWeakReference);
		}
		*/
		/**
		 *
		 */
		public function register(pId:int, pFunc:Function, pDesc:String=""):void
		{
			//
			if (!hasRegister(pId, pFunc, pDesc))
			{
				var funcs:Vector.<IFunc>=_pushList.take(pId.toString()) as Vector.<IFunc>
				if (!funcs)
				{
					funcs=new Vector.<IFunc>;
					_pushList.put(pId.toString(), funcs);
				}
				funcs.push(new FuncModel(pId, pFunc, pDesc));
			}
		}

		public function hasRegister(pId:int, pFunc:Function, pDesc:String=""):Boolean
		{
			//新的检查方法改用管理方式实现
			var funcs:Vector.<IFunc>=_pushList.take(pId.toString()) as Vector.<IFunc>
			if (funcs && funcs.length)
			{
				for (var i:int=0; i < funcs.length; i++)
				{
					if (pFunc == funcs[i].GetFunc() && pDesc == funcs[i].GetDesc() && false == funcs[i].GetDeleteTag())
					{
						return true;
					}
				}
			}
			return false
			//下边是老的方法 by saiman
//			var len:int=_fList.length;
//			var iFunc:Vector.<IFunc>;
//			
//			for (var i:int=0; i < len; i++)
//			{
//				if (pId == _fList[i].Id && pFunc == _fList[i].GetFunc() && pDesc == _fList[i].GetDesc() && false == _fList[i].GetDeleteTag())
//				{
//					return true;
//				} //end if
//
//			} //end for
//
//			return false;
		}

		private function removeInProcess(pId:int, pFunc:Function):void
		{
			var funcs:Vector.<IFunc>=_pushList.take(pId.toString()) as Vector.<IFunc>
			if (funcs)
			{
				for (var i:int=0; i < funcs.length; i++)
				{
					if (pFunc == funcs[i].GetFunc() && funcs[i].GetDeleteTag())
					{
						//delete
						var iFunc:Vector.<IFunc>=funcs.splice(i, 1);
						//delete reference
						if (null != iFunc && iFunc.length > 0)
						{
							iFunc[0].Destory();
						}
						return;
					} //end if
				}
			}
			return
			//下边是老的方法实现
//			var len:int=_fList.length;
//			var iFunc:Vector.<IFunc>;
//
//			for (var i:int=0; i < len; i++)
//			{
//				if (pId == _fList[i].Id && pFunc == _fList[i].GetFunc() && true == _fList[i].GetDeleteTag())
//				{
//					//delete
//					iFunc=_fList.splice(i, 1);
//
//					//delete reference
//					if (null != iFunc && iFunc.length > 0)
//					{
//						iFunc[0].Destory();
//					}
//
//					return;
//				} //end if
//
//			} //end for
//			//指定不存在
//			return;
			//	throw new Error("can not find pId:" + pId.toString() + " Func:remove Class:DataKey");
		}

		/**
		 * 删除指定
		 */
		public function remove(pId:int, pFunc:Function):void
		{
			var funcs:Vector.<IFunc>=_pushList.take(pId.toString()) as Vector.<IFunc>
			if (funcs)
			{
				for (var i:int=0; i < funcs.length; i++)
				{
					if (pFunc == funcs[i].GetFunc() && !funcs[i].GetDeleteTag())
					{
						funcs[i].SetDeleteTag(true);
					}
				}
			}
			return
//		下边是老的实现
//			var len:int=_fList.length;
//			var iFunc:IFunc;
//			for each (iFunc in _fList)
//			{
//				if (pId == iFunc.Id && pFunc == iFunc.GetFunc() && false == iFunc.GetDeleteTag())
//				{
//					iFunc.SetDeleteTag(true);
//					//this.removeInProcess(iFunc.Id, iFunc.GetFunc());
//					return;
//				}
//			}
		}

		/**
		 * 删除多个
		 */
		public function removeByPID(pId:int):void
		{
			var funcs:Vector.<IFunc>=_pushList.take(pId.toString()) as Vector.<IFunc>
			if (funcs)
			{
				for (var i:int=0; i < funcs.length; i++)
				{
					if (!funcs[i].GetDeleteTag())
					{
						funcs[i].SetDeleteTag(true);
					}
				}
			}
			return
			//下边是老的实现
//			var len:int=_fList.length;
//			var iFunc:IFunc;
//			for each (iFunc in _fList)
//			{
//				if (pId == iFunc.Id && false == iFunc.GetDeleteTag())
//				{
//					iFunc.SetDeleteTag(true);
//					//this.removeInProcess(iFunc.Id, iFunc.GetFunc());
//				}
//			}
		}

		/**
		 * 删除多个
		 */
		public function removeByFunc(pFunc:Function):void
		{
			for each (var funcs:Vector.<IFunc> in _pushList)
			{
				if (funcs)
				{
					for (var j:int=0; j < funcs.length; j++)
					{
						if (pFunc == funcs[j].GetFunc() && false == funcs[j].GetDeleteTag())
						{
							funcs[j].SetDeleteTag(true);
						}
					}
				}
			}
			//
			return
//			var len:int=_fList.length;
//			var iFunc:IFunc;
//			for each (iFunc in _fList)
//			{
//				if (pFunc == iFunc.GetFunc() && false == iFunc.GetDeleteTag())
//				{
//					iFunc.SetDeleteTag(true);
//					//this.removeInProcess(iFunc.Id, iFunc.GetFunc());
//				}
//			}
		}

		//TODO 需要优化
//		public function Process_war(p:IPacket):void
//		{
//			DataKeyProcess.process(p);
//			var m_ifunc:IFunc;
//			for each (m_ifunc in _fList)
//			{
//				if (m_ifunc.Id == p.GetId())
//				{
//					m_ifunc.GetFunc() == null ? "" : m_ifunc.GetFunc()(p);
//				}
//			}
//		}
		/**
		 * 存储反序列化后的数据
		 * 负带有监控的功能---Warren
		 **/
		public function receive(p:IPacket):void
		{
			_cList.push(p);
		}

		/**
		 *
		 *
		 */
		public function process(count:int=60):void
		{
			var i:int;
			var j:int;
			var len:int;
			var f:Function;
			var p:IPacket;
			var iFunc:IFunc;
			//------------------- sleep mode begin -------------------
			if (this._sleep && this._sleepCurrentCount < DataKey.sleepMaxCount)
			{
				this._sleepCurrentCount++;
				return;
			}
			this._sleep=false;
			this._sleepCurrentCount=0;
			this._playerEnterGridCount=0;
			this._monsterEnterGridCount=0;
			this._objLeaveGridCount=0;
			this._sayMapCount=0;
			//------------------- sleep mode end -------------------
			//------------------- remove begin ----------------------
			//一次性删完
			if (this._delList.length > 0)
			{
				len=this._delList.length;
				for (i=0; i < len; i++)
				{
					iFunc=this._delList.shift();
					this.removeInProcess(iFunc.GetId(), iFunc.GetFunc());
				}
			}
//			if (_cList.length > 100)
//				count=_cList.length;
			count=_cList.length;
			for (i=0; i < count; i++)
			{
				//----------------------------------------------------------		
				//if(_cList.length > 0 && _socket.connected)		
				//接收数据处理不需要判断网络是否已连接
				if (_cList.length > 0)
				{
					//现不采用派发事件
					p=DataKeyProcess.process(_cList.shift());
					var list:Vector.<IFunc>=_pushList.take(p.GetId().toString()) as Vector.<IFunc>
					if (list)
					{
						for (j=0; j < list.length; j++)
						{
							if (list[j].GetFunc() != null && !list[j].GetDeleteTag())
							{
								f=list[j].GetFunc();
								f(p);
							}
						}
					}
					if (PacketSCRelive.id == p.GetId())
					{
						sleep=false;
						return;
					}
					else if (PacketSCMapSend.id == p.GetId())
					{
						this.sleep=true;
						return;
					}
					else if (PacketSCPlayerEnterGrid.id == p.GetId())
					{
						_playerEnterGridCount++;
						if (_playerEnterGridCount > playerEnterGridMaxCount)
						{
							break;
						}
					}
					else if (PacketSCMonsterEnterGrid.id == p.GetId())
					{
						_monsterEnterGridCount++;
						if (_monsterEnterGridCount > monsterEnterGridMaxCount || _objLeaveGridCount > objLeaveGridMaxCount)
						{
							break;
						}
					}
					else if (PacketSCObjLeaveGrid.id == p.GetId())
					{
						_objLeaveGridCount++;
						if (_monsterEnterGridCount > monsterEnterGridMaxCount || _objLeaveGridCount > objLeaveGridMaxCount)
						{
							break;
						}
					}
					else if (PacketSCSayMap.id == p.GetId())
					{
						_sayMapCount++;
						if (_sayMapCount > sayMapMaxCount)
						{
							break;
						}
					}
				}
				else if (_cList.length == 0)
				{
					break;
				}
			}
		}
		private var sendDelay:int=200; //毫秒
		private var currSendTime:Dictionary=new Dictionary();

		/**
		 * 发送数据
		 */
		public function send(p:IPacket):void
		{
			_socket.send(p);
		}
		private var t:int;
		private var m_prev_5000:int;
		private var m_prev_300:int;
		//private var heartCount:int = 0;
		private var _runCount:int=0;

		public function RunCountHandler(e:WorldEvent):void
		{
			_runCount++;
		}

		/**
		 * 心跳包，三秒一次
		 */
		//public function HeartHandler(e:WorldEvent):void
		public function HeartHandler(e:TimerEvent):void
		{
			//换新的方法，二次时间差为5000时发
			if (this.connected())
			{
				t=getTimer();
				if (t - m_prev_5000 >= 5000)
				{
					m_prev_5000=t;
					var p:PacketCSSysHeart=new PacketCSSysHeart();
					p.time=m_prev_5000;
					this.send(p);
				}
				if (t - m_prev_300 >= 300)
				{
					m_prev_300=t;
				}
			}
		}
	}
}
