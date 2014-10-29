package scene.manager
{
	import flash.geom.Point;
	
	import ghostcat.algorithm.traversal.ITestNode;
	import ghostcat.algorithm.traversal.MapModel;
	import ghostcat.algorithm.traversal.Node;
	import ghostcat.algorithm.traversal.SimpleAStar;
	
	public class AlchemyManager extends MapModel implements ITestNode
	{
		static private var _instance:AlchemyManager;
		private var m_astar :SimpleAStar;
		private var m_mapId :int 
		
		public function get mapId():int
		{
			return m_mapId;
		}

		public function set mapId(value:int):void
		{
			m_mapId = value;
		}

		public function AlchemyManager()
		{
			super(this);
			m_astar = new SimpleAStar(this);
		}
		
		public function test(node :Node) :Boolean
		{
			if(node == null)
				return false;
			return ((node.data & 0x1) == 0);	
		}
		public function canMoveTo(cols :int ,rows :int ) :Boolean
		{
			var node :Node = getNode(cols,rows);
			return test(node);
		}
		
		public function isWalkable(p:Point):Boolean
		{
			return canMoveTo(p.x,p.y);
		}
		
		public function initMapData(mapId_:int,datas :Array):void
		{
			m_mapId = mapId_;
			this.map = [];
			arrNode=[];
			var rows :int = datas.length;
			var cols:int = datas[0].length;
			for (var i:int = 0; i < cols; i++) 
			{
				var arr :Array = [];
				map.push(arr);
				for (var j:int = 0; j < rows; j++) 
				{
					var value:int=datas[j][i];
//					var node :Node = new Node();
					var node :Node = poolGetNode(i,j);
					if(value == 0)
						node.data = 1
					else if(value == 1)
						node.data = 0;
					else if(value == 2)
						node.data = 1<<1;
					arr.push(node);
				}
			}
		}
		private var arrNode:Array=[];
		private function poolGetNode(m_j:int,m_i:int):Node{
			if(arrNode[m_i]==null)
				arrNode[m_i]=[];
			var m_node:Node=arrNode[m_i][m_j] as Node;
			if(m_node==null){
				m_node=new Node();
				arrNode[m_i][m_j]=m_node;
			}
			return m_node;
		}
		public function getPath(sX :int ,sY :int ,toX :int ,toY :int ,path :Array,depth :int = 5000)  :int
		{
			var result :int = m_astar.find(new Point(sX,sY),new Point(toX,toY),path,depth);
			return result;
		}
		
		public static function get instance():AlchemyManager
		{
			if(!_instance)
				_instance = new AlchemyManager();
			return _instance;
		}
		//		protected function initAlchemy():void
		//		{
		//			CModule.startAsync(this);
		//			alcTPointer = CModule.malloc(4 * 1024*200);
		//			init(alcTPointer);
		//
		//		}
		
		//		public function initMap(map_id:int,x:int,y:int,pool:Array):void
		//		{
		//			var num_total:int = 0;
		//			
		//			for each (var item:int in pool)
		//			{
		//				CModule.write32(alcTPointer + (num_total * 4), item);
		//				num_total += 1;				
		//			}
		//			
		//			if(num_total > 0)
		//			{				
		//				num_total = num_total/4;			
		//				initializeRect(x,y,map_id,num_total);
		//			}
		//		}
		
		//TODO 这个寻路函数非常卡
		//		public function find(map_id:int,x1:int,y1:int,x2:int,y2:int,pool:Array):int
		//		{
		//			
		////			if(ReadMapData.blockMode)
		////			{
		////				finePath(x1,y1,x2,y2,pool);
		////				if(pool.length==0)return -1;
		////				return pool.length;
		////			}
		//			
		//			findAStarPath(x1,y1,x2,y2,map_id);
		//			
		//			var pathlen:int = CModule.read32(alcTPointer);
		//			if(pathlen == -1)
		//			{
		//				return -1;
		//			}
		//			var x:int;
		//			var y:int;
		//			pathlen = pathlen*2;
		//			for(var i:int = 0;i < pathlen;)
		//			{
		//				x = CModule.read32(alcTPointer+(i+1)*4);
		////				pool.push(x);
		//				y = CModule.read32(alcTPointer+(i+2)*4);
		////				pool.push(y);					
		//				pool.push(new Point(x,y));
		//				i = i + 2;
		//			}
		//			return pathlen/2;
		//		}
		
		
		
		//		private var astar:SquareAstar=new SquareAstar
		//		private var startPt:SquarePt=new SquarePt
		//		private var endPt:SquarePt=new SquarePt
		//		
		//		public function finePath(x1:int,y1:int,x2:int,y2:int,pool:Array):void
		//		{
		//			
		//		
		//			var array:Array=getPath(new Point(x1,y1),new Point(x2,y2),5000)
		//			for (var i:int = 0; i < array.length; i++) 
		//			{
		//				
		//				
		//				var pt:Square=SquareGroup.getInstance().take( SquareUitls.pixelsToSquare(new Point(array[i].x,array[i].y)).key);
		//				if(pt)
		//				{
		//					pool.push([pt.midVertex.x,pt.midVertex.y])
		//				
		//				}
		//			}
		//			
		//			
		//		}
		
		
		//		private function checkPointType(star_point:Point,tar_point:Point,px:int=10):Boolean
		//		{
		//			var star_point:Point=star_point;
		//			var dis:Number=Point.distance(star_point,tar_point);
		//			var index:int=Math.ceil(dis/px);
		//			var bool:Boolean=true;
		//			for(var i:int=0;i<index;i++)
		//			{
		//				var point:Point=Point.interpolate(star_point,tar_point,(i/index));
		//				var pt:SquarePt=SquareUitls.pixelsToSquare(point)
		//				var cell:Square=SquareGroup.getInstance().take(pt.key)
		//				if(!cell||(cell.type<1&&cell.type!=this.astar.mode))
		//				{
		//					bool=false
		//					break;
		//					
		//				}
		//			}
		//			return bool
		//		}
		
		//
		//		
		//		public function getPath(start_point:Point,end_point:Point,breakSetp:int=1000):Array
		//		{
		//			
		//			var array:Array;
		//			var pt_start:SquarePt=SquareUitls.pixelsToSquare(start_point)
		//			var pt_end:SquarePt=SquareUitls.pixelsToSquare(end_point)
		////			if(pt_start.key==pt_end.key)
		////			{
		////				var p:Point=PathUtils.getTeleportPath(start_point,end_point,60,250)
		////				return [start_point,p];
		////				return [start_point,end_point]
		////			}else if(checkPointType(start_point,end_point))
		////			{
		////				array=[start_point,end_point];
		////				//可直线行走
		////			}else{
		//				
		//				
		//				//不可直线行走则寻路
		//				array=this.astar.getPath(SquareGroup.getInstance().hash.hash,pt_start,pt_end,true,breakSetp)
		//				if(array.length)
		//				{
		//					var end:Point=array[array.length-1];
		//					//判断最后一个点是否跟预期的目标点位于相同的格子上，是则替换预期目标点位置
		//					if(SquareUitls.pixelsToSquare(end).key==pt_end.key)array[array.length-1]=end_point;
		//					//判断寻路得到的第一个格子坐标是否与当前角色的位置相同，相同时替换
		//					var startPoint:Point=array[0];
		//					if(SquareUitls.pixelsToSquare(startPoint).key==pt_start.key)
		//					{
		//						if(pt_start.toString()!=start_point.toString())
		//						{
		//							
		//							array[0]=start_point
		//						}
		//					}
		//					
		//					
		//				}
		//				
		//				//整理路径删除相同方向的点
		//				array=cleanPath(array)
		//				
		////			}
		//			return array
		//		}
		
		
		
		
		//		/**
		//		 *  整理路径，删除相同方向的点 
		//		 * @param array
		//		 * @return 
		//		 * 
		//		 */		
		//		public function cleanPath(array:Array):Array
		//		{
		//			if(array.length>2)
		//			{
		//				for(var i:int=1;i<array.length-1;i++)
		//				{
		//					var prve_p:Point=array[i-1];
		//					var curr_p:Point=array[i]
		//					var next_p:Point=array[i+1]
		//					
		//					var k1:Number=(prve_p.y-curr_p.y)/(prve_p.x-curr_p.x);
		//					var k2:Number=(curr_p.y-next_p.y)/(curr_p.x-next_p.x);
		//					
		//					if(k1==k2)
		//					{
		//						array.splice(i,1)
		//						i--
		//					}
		//					
		//				}
		//			}
		//			return  array
		//		}
	}
}