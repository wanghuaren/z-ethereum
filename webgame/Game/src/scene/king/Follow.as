/**
 *auother:Administrator
 *date:2013-1-5_上午9:59:12
 **/
package scene.king
{
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Point;

	import scene.utils.MapCl;

	public class Follow extends Sprite
	{
		private var _roleList:Vector.<IGameKing>=new Vector.<IGameKing>();

//		private static var _instance:Follow;
//
//		public static function get instance():Follow
//		{
//			if (_instance == null)
//			{
//				_instance=new Follow();
//			}
//			return _instance;
//		}

		public function Follow()
		{

		}

		/**
		 * 添加被跟随物体的轨迹点
		 * */
		public function addTrackPoint(value:FollowC):void
		{
			trackPoint.push(value);
			roleListMove();
		}

		public function set roleList(value:Vector.<IGameKing>):void
		{
			_roleList=value;
		}
		
		public function get roleList():Vector.<IGameKing>
		{
			return _roleList;
		}

		/**
		 * 设置物体之间的距离步长，默认10步
		 * */
		public function set count(value:int):void
		{
			_count=value;
		}
		private var trackPoint:Vector.<FollowC>=new Vector.<FollowC>();
		private var _count:int=20;//10;

		private function roleListMove():void
		{
			var m_role:IGameKing;
			var curr_status:FollowC;
			for (var i:int=0; i < _roleList.length; i++)
			{
				if (trackPoint.length > (i + 1) * _count)
				{
					m_role=_roleList[i];
					curr_status=trackPoint[trackPoint.length - (i + 1) * _count];
					m_role.x=curr_status.x;
					m_role.y=curr_status.y;
					MapCl.setFangXiang(m_role.getSkin().getRole(), curr_status.act, curr_status.direct, m_role);
				}
				else
				{
					break;
				}
			}
			if (trackPoint.length > (_roleList.length + 1) * _count)
			{
				trackPoint.shift();
			}
		}
	}
}
