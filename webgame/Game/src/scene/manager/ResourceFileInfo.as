package scene.manager
{
	import engine.load.Loadres;
	
	import flash.utils.getTimer;
	
	import world.type.BeingType;

	public class ResourceFileInfo
	{
		private var _count:int;

		/**
		 * 加入时间
		 */
		private var _t:int;

		/**
		 * 是否自身
		 */
		private var _isMe:Boolean;
		private var _isMePet:Boolean;

		/**
		 *
		 */
		private var _name2:String;

		/**
		 *
		 */
		private var _loadresArray:Array;

		private var _skinArray:Array;

		/**
		 *
		 */
		public function isSameSkin(value:Array):Boolean
		{
			
			if(null != _skinArray && 
			   _skinArray.length == value.length)
			{
				var len:int = _skinArray.length;
				for(var n:int=0;n<len;n++)
				{
					if(_skinArray[n] == value[n])
					{
						
					}else{
						return false;
					}
					
				}//end for
				
				return true;
			}
			
			return false;
		}

		public function ResourceFileInfo(king_name2:String, king_isMe:Boolean, king_isMePet:Boolean, loadresArray:Array, skinArray:Array, count:int)
		{
			_t=getTimer();
			_count=count;
			_name2=king_name2;
			_isMe=king_isMe;
			_isMePet=king_isMePet;
			_loadresArray=loadresArray;
			_skinArray=skinArray;
		}


		

		public function load():void
		{
			var i:int;
			for (i=0; i < _count; i++)
			{
				this._loadresArray[i].load([_skinArray[i]]);
			}
		}


		/*public function get ld_loading():Boolean
		{
			return _ld_loading;
		}*/

		public function get t():int
		{
			return _t;
		}

		public function get priorityByIsMe():int
		{
			if (_isMe)
			{
				return 0;
			}
			return 1;
		}

		public function get priorityByIsMePet():int
		{
			if (_isMePet)
			{
				return 0;
			}
			return 1;
		}

		public function get priorityByBeingType():int
		{
			if (_name2.indexOf(BeingType.NPC) >= 0)
			{
				return 0;
			}

			if (_name2.indexOf(BeingType.MON) >= 0)
			{
				return 1;
			}

			if (_name2.indexOf(BeingType.MONSTER) >= 0)
			{
				return 2;
			}

			if (_name2.indexOf(BeingType.HUMAN) >= 0)
			{
				return 3;
			}

			return 4;
		}





























	}
}
