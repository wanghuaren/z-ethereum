package scene.skill2
{
	import common.utils.clock.GameClock;
	
	import engine.utils.HashMap;
	
	import netc.Data;
	import netc.packets2.PacketSCPetData2;
	
	import scene.action.Action;
	import scene.king.IGameKing;
	import scene.manager.SceneManager;
	
	import world.WorldEvent;
	import world.WorldFactory;


	public class WaftNumManager
	{
		/**
		 *
		 */
		private static var _instance:WaftNumManager;

		/**
		 * 普通飘字
		 */
		private var _wnList:HashMap;

		/**
		 * 小蓝字
		 */
		private var _wnList2:HashMap;

		/**
		 * 减血算总和
		 */
		private var _wnHpSubList:HashMap;


		/**
		 * 格档，1秒内不管多少次，只算1次
		 */
		private var _wnHpSubGeDaList:HashMap;

		
		private var _wnLvlList:HashMap;

		public function WaftNumManager()
		{
			GameClock.instance.addEventListener(WorldEvent.CLOCK__SECOND200, clockMs100ByLvl);
			
			GameClock.instance.addEventListener(WorldEvent.CLOCK_HALF_OF_SECOND, clockMs500);

			GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND, clockMs1000);
		}

		public static function get instance():WaftNumManager
		{
			if (!_instance)
			{
				_instance=new WaftNumManager();
			}

			return _instance;
		}

		public function saveHpSubTotal(enemyKing_objid:int, value:Number, enemyKing_hp:int, type:String, otherParam:Object=null):void
		{

			if (!wnHpSubList.containsKey(enemyKing_objid))
			{
				wnHpSubList.put(enemyKing_objid, []);
			}

			var subList:Array=wnHpSubList.get(enemyKing_objid);
			subList.push({enemyKing_objid: enemyKing_objid, value: value, enemyKing_hp: enemyKing_hp, type: type, otherParam: otherParam}

				);


		}

		public function saveHpSubGeDa(enemyKing_objid:int, value:int, enemyKing_hp:int, type:String, otherParam:Object=null):void
		{

			if (!wnHpSubGeDaList.containsKey(enemyKing_objid))
			{
				wnHpSubGeDaList.put(enemyKing_objid, []);
			}

			var subList:Array=wnHpSubGeDaList.get(enemyKing_objid);

			subList.push({enemyKing_objid: enemyKing_objid, value: value, enemyKing_hp: enemyKing_hp, type: type, otherParam: otherParam}

				);


		}
		
		public function saveLvl(enemyKing_objid:int, value:int, enemyKing_hp:int, type:String, otherParam:Object=null):void
		{
			
			if (!wnLvlList.containsKey(enemyKing_objid))
			{
				wnLvlList.put(enemyKing_objid, []);
			}
			
			var subList:Array=wnLvlList.get(enemyKing_objid);
			
			subList.push({enemyKing_objid: enemyKing_objid, value: value, enemyKing_hp: enemyKing_hp, type: type, otherParam: otherParam}
				
			);
			
			
		}
		
		

		public function save(wn:WaftNumber):void
		{
			//list push

			var libName:String=wn.kingObjId.toString();
			var type:String=wn.type;

			if (type.indexOf("lvlup") == 0)
			{
				saveToList(this.wnList2, wn, libName);
			}
			else
			{
				saveToList(this.wnList, wn, libName);
			}

		}

		private function saveToList(wnListX:HashMap, wn:WaftNumber, libName:String):void
		{
			if (!wnListX.containsKey(libName))
			{
				wnListX.put(libName, []);
			}

			var subList:Array=wnListX.get(libName);
			subList.push(wn);

//			wn.show();
		}
		
		public function clockMs100ByLvl(e:WorldEvent):void
		{
			sendLvl(this.wnLvlList);
		}
		
		
		

		public function clockMs500(e:WorldEvent=null):void
		{
			//return;
			var wnHpSubListKeys:Array=wnHpSubList.keys();
			var len:int=wnHpSubListKeys.length;

			var myKing_objid:int=Data.myKing.objid;
			var myKing_king:IGameKing=Data.myKing.king;

			//
			var i:int;
			var subList:Array;
			for (i=0; i < len; i++)
			{
				if (wnHpSubList.containsKey(wnHpSubListKeys[i]))
				{
					subList=wnHpSubList.get(wnHpSubListKeys[i]);

					if (subList.length > 0)
					{

						var jLen:int=subList.length;

						var total:Number=0;
						var type:String=WaftNumType.HP_SUB;
						var otherParam:Object=null;
						var enemyKing_objid:int=0;

						for (var j:int=0; j < jLen; j++)
						{
							total+=subList[j]["value"];
							otherParam=subList[j]["otherParam"];
							enemyKing_objid=subList[j]["enemyKing_objid"];
						}

						var k:IGameKing;
						if (enemyKing_objid == myKing_objid && null != myKing_king)
						{
							k=myKing_king;
						}
						else
						{
							k=SceneManager.instance.GetKing_Core(enemyKing_objid);
						}

						subList.splice(0, jLen);

						if (null == k)
						{
							continue;
						}

						if (0 == total)
						{
							continue;
						}

						//Action.instance.fight.ShowWaftNumberCore(k, total, k.hp, type, otherParam);
						var skn:WaftNumber=WorldFactory.createWaftNumber();
						
						//
						skn.setData(k, total, type, otherParam);
						
						skn.show();
						
					}
				} //end if

			}


			len=wnHpSubListKeys.length;

			//执行清理工作
			if (len >= 50)
			{

				for (i=0; i < len; i++)
				{
					if (wnHpSubList.containsKey(wnHpSubListKeys[i]))
					{
						subList=wnHpSubList.get(wnHpSubListKeys[i]);

						if (subList.length == 0)
						{
							wnHpSubList.remove(wnHpSubListKeys[i]);

						}

					} //end if	

				} //end for

			}

			
		}
		
		public function clockMs1000(e:WorldEvent=null):void
		{
			//
			this.sendGeDa(this.wnHpSubGeDaList);
		}

		public function clockMs100And200(e:WorldEvent):void
		{
			clockSecond100(e);
			clockSecond200(e);
		}

		private function clockSecond100(e:WorldEvent):void
		{
			send(wnList);

		}

		private function clockSecond200(e:WorldEvent):void
		{
			send(wnList2);

		}
		
		//private var srcid:int;
		//private var targetid:int

		public function showTrail(targetid_:int, srcid_:int):void
		{
			//return;
//			targetid=targetid_;
//			srcid=srcid_;
//			send(wnList);
			this.clockMs500();
		}

		public function DelAll():void
		{
			//wnList2不需要删

			wnList.clear();
			wnHpSubList.clear();
			wnHpSubGeDaList.clear();
		}


		public function send(wnListX:HashMap):void
		{
			var wnkeys:Array=wnListX.keys();
			var len:int=wnkeys.length;

			//脚本超时15秒?
			//len > 150,下面会进行清理，消除无用的空key

			//
			var i:int;
			var subList:Array;
			for (i=0; i < len; i++)
			{
				if (wnListX.containsKey(wnkeys[i]))
				{
					subList=wnListX.get(wnkeys[i]);

					if (subList.length > 0)
					{
						(subList.shift() as WaftNumber).show();
						
					}


				} //end if

			}

			//delete
			len=wnkeys.length;

			//执行清理工作
			if (len >= 150)
			{

				for (i=0; i < len; i++)
				{
					if (wnListX.containsKey(wnkeys[i]))
					{
						subList=wnListX.get(wnkeys[i]);

						if (subList.length == 0)
						{
							wnListX.remove(wnkeys[i]);
						}
					} //end if	
				} //end for
			}
		}
		
		
		public function sendGeDa(wnListX:HashMap):void
		{
			var wnkeys:Array=wnListX.keys();
			var len:int=wnkeys.length;
			
			if(0 == len){
				return;
			}			
			
			//脚本超时15秒?
			//len > 150,下面会进行清理，消除无用的空key
			var myKing_objid:int=Data.myKing.objid;
			var myKing_king:IGameKing=Data.myKing.king;
			
			//
			var i:int;
			var subList:Array;
			for (i=0; i < len; i++)
			{
				if (wnListX.containsKey(wnkeys[i]))
				{
					subList=wnListX.get(wnkeys[i]);
					
					if (subList.length > 0)
					{
						//(subList.shift() as WaftNumber).show();
						
						var o:Object = subList.shift();
						
						if (subList.length > 0)
						{
							subList.splice(0,subList.length);
						}
						
						var k:IGameKing;
						var enemyKing_objid:uint = o["enemyKing_objid"];
						
						if (enemyKing_objid == myKing_objid && null != myKing_king)
						{
							k=myKing_king;
						}
						else
						{
							k=SceneManager.instance.GetKing_Core(enemyKing_objid);
						}
						
						//
						if(null == k)
						{
							break;
						}
						
						var skn:WaftNumber=WorldFactory.createWaftNumber();
						
						//
						skn.setData(k, o["value"], o["type"], o["otherParam"]);
						
						skn.show();
						
						
						break;
					}
					
					
				} //end if
				
			}
			
			//delete
			len=wnkeys.length;
			
			//执行清理工作
			if (len >= 50)
			{
				
				for (i=0; i < len; i++)
				{
					if (wnListX.containsKey(wnkeys[i]))
					{
						subList=wnListX.get(wnkeys[i]);
						
						if (subList.length == 0)
						{
							wnListX.remove(wnkeys[i]);
						}
					} //end if	
				} //end for
			}
		}
		
		
		public function sendLvl(wnListX:HashMap):void
		{
			var wnkeys:Array=wnListX.keys();
			var len:int=wnkeys.length;
			
			if(0 == len){
				return;
			}			
			
			//脚本超时15秒?
			//len > 150,下面会进行清理，消除无用的空key
			var myKing_objid:int=Data.myKing.objid;
			var myKing_king:IGameKing=Data.myKing.king;
			
			//
			var i:int;
			var subList:Array;
			for (i=0; i < len; i++)
			{
				if (wnListX.containsKey(wnkeys[i]))
				{
					subList=wnListX.get(wnkeys[i]);
					
					if (subList.length > 0)
					{
						//(subList.shift() as WaftNumber).show();
						
						var o:Object = subList.shift();
						
						var k:IGameKing;
						var enemyKing_objid:uint = o["enemyKing_objid"];
						
						if (enemyKing_objid == myKing_objid && null != myKing_king)
						{
							k=myKing_king;
						}
						else
						{
							k=SceneManager.instance.GetKing_Core(enemyKing_objid);
						}

						//
						if(null == k)
						{
							break;
						}
						
						var skn:WaftNumber=WorldFactory.createWaftNumber();
						
						//
						skn.setData(k, o["value"], o["type"], o["otherParam"]);
						
						skn.show();
						
						break;
					}
					
					
				} //end if
				
			}
			
			//delete
			len=wnkeys.length;
			
			//执行清理工作
			if (len >= 50)
			{
				
				for (i=0; i < len; i++)
				{
					if (wnListX.containsKey(wnkeys[i]))
					{
						subList=wnListX.get(wnkeys[i]);
						
						if (subList.length == 0)
						{
							wnListX.remove(wnkeys[i]);
						}
					} //end if	
				} //end for
			}
		}



		//get

		public function get wnList():HashMap
		{
			if (null == _wnList)
			{
				_wnList=new HashMap();
			}

			return _wnList;
		}


		public function get wnList2():HashMap
		{
			if (null == _wnList2)
			{
				_wnList2=new HashMap();
			}

			return _wnList2;
		}

		public function get wnHpSubList():HashMap
		{

			if (null == _wnHpSubList)
			{
				_wnHpSubList=new HashMap();
			}

			return _wnHpSubList;

		}


		public function get wnHpSubGeDaList():HashMap
		{
			if (null == _wnHpSubGeDaList)
			{
				_wnHpSubGeDaList=new HashMap();
			}
			return _wnHpSubGeDaList;
		}
		
		
		public function get wnLvlList():HashMap
		{
			if (null == _wnLvlList)
			{
				_wnLvlList=new HashMap();
			}
			return _wnLvlList;
		
		}
		
		
	}
}
