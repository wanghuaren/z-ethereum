package com.engine.utils.astar
{


	import com.engine.core.tile.Cell;
	import com.engine.core.tile.Pt;
	import com.engine.utils.Track;
	import com.engine.utils.gome.TileUitls;
	
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	


	/**
	 * astart
	 * @author sai
	 *
	 */
	public class Astar
	{
		//水平垂直代价消耗
		private static const COST_STRAIGHT:int=10;
		//对角代价消耗
		private static const COST_DIAGONAL:int=14;
		//9宫格四中点方向
		private static const DIR_TC:String='tc';
		private static const DIR_CT:String='ct';
		private static const DIR_CR:String='cr';
		private static const DIR_BC:String='bc';
		//前段测试用绘图对象可忽略
		public var g:Graphics
		//寻路遍历过程中的当前节点对象
		private var nonce:AstarData;
		//完成或跳出判断
		private var isFinish:Boolean;
		//全局G值，用于计算当前累积代价
		private var G:int;
		// 数据源字典类，元素为Cell 对象
		private var source:Dictionary;
		//开始点
		private var startPoint:Pt
		//结束点
		private var endPoint:Pt
		//关闭列表查询用字典类 ，数据元素为AstarData对象
		private var colsePath:Dictionary;
		//关闭类表数组形式，数据元素为AstarData对象
		private var colseArray:Array;
		//开放列表字典类形式，用于方便查询，数据元素为AstarData对象
		private var openPath:Dictionary;
		//开放列表数组形式，用于数据的排序，数据元素为AstarData对象
		private var openArray:Array;
		//结果路径数组，每次寻路整理的结果
		private var pathArray:Array
		//每次逸代的九宫格的8方向开关
		//九宫格4中点方向开关
		private var canTL:Boolean;
		private var canTR:Boolean;
		private var canBL:Boolean;
		private var canBR:Boolean;
		//九宫格4斜角方向开关
		private var canTC:Boolean;
		private var canCT:Boolean;
		private var canCR:Boolean;
		private var canBC:Boolean;
		// 关闭列表长度
		private var closeLength:int
		//寻路模式，模式为1时，只认为模式对应的类型为通过类型。
		//用于进行跳跃点跟一般可走路径的区别寻路
		//值为1时表示一般的可走点的寻路，值为2时忽略一般可走类型只对可跳跃类型进行寻路
		public var mode:int=1
		
		public function Astar()
		{

		}

		/**
		 * 寻路
		 * @param source 数据源
		 * @param startPoint 开始点
		 * @param endPoint 结束点
		 * @param isFineNear 是否为全路径查找模式
		 * @param breakSetp isFineNear为false时 启用搜索步限制.默认值1000
		 * @return
		 *
		 */

		public function getPath(source:Dictionary, startPoint:Pt, endPoint:Pt, isFineNear:Boolean=true, breakSetp:int=10000):Array
		{
			if(source[startPoint.key])
			{
				var cell:Cell=source[startPoint.key] as Cell
				var cell2:Cell=	source[endPoint.key] as Cell
				if(cell&&cell2)
				{
					
					if (cell.type==2&&cell2.type==2){
						this.mode=2;
					}else {
						this.mode=1
					}
				}else {
					this.mode=1
				}
			}
			if((!source[startPoint.key])||(this.mode==1&&source[startPoint.key]&&source[startPoint.key].type==2))
			{
				return [];
			}
			
//			//测试用，寻路耗时开始计数
//			var t:Number=getTimer();
			//，每次寻路重新初始化
			reSet();
			//当开始点或者结束点部可走或者不存在时，自动求取可走的开始点跟结束点
			this.startPoint=cycleCheck(source,startPoint,0)
			this.endPoint=cycleCheck(source,endPoint,0)
			//赋值当前数据源
			this.source=source
			//设定开始的节点对象
			this.nonce=new AstarData(0,0,this.startPoint)
			//设定开始节点的父级
			this.nonce.parent=this.nonce;
			//将当前节点放入关闭列表
			this.colsePath[this.nonce.key]=this.nonce
			//进行逸代寻路
			while(this.isFinish){
				getScale9Grid(source,this.nonce,this.endPoint,breakSetp)
					
			}
			
			//  整理关闭列表数据，得到最后的路径
			var array:Array= cleanArray();
//			//测试用，寻路结束后计算总花费时间
//			Track.track('saiman','*****************路径长: ',array.length,'  寻路时间',getTimer()-t,'*******************','\n\n')
//				
			
			return  array
		}
		/**
		 * 强制停止当前寻路 
		 * 
		 */		
		public function stop():void
		{
			this.isFinish=false
		}

		
		private function cycleCheck(source:Dictionary, endPt:Pt,level:int):Pt
		{
			var type:int
			mode==1?type=2:type=1
//			type=2
			if (source[endPt.key] == null || source[endPt.key].type == 0||source[endPt.key].type == type)
			{
				var px:int=endPt.x;
				var py:int=endPt.z;
				var c:Cell=new Cell
				c.index=endPt;
				var array:Array;
				var key:String;
				var cell:Cell
				for(var x:int=(px-(level+1));x<=(px+(level+1));x++)
				{
					array=[]
					for(var y:int=(py-(level+1));y<=(py+(level+1));y++)
					{
						
						key=x+'|'+0+'|'+y;
						if(key!=endPt.key){
							cell=source[key];
							
								if (cell != null && cell.type != 0 && cell.type != type)
								{
									array.push({cell:cell,dis:Point.distance(cell.midVertex,c.midVertex)})
									return cell.index;
									break
								}
							
						}

					}
					if(array.length>0){
						array.sortOn('dis',Array.NUMERIC)
						return array[0].cell.index;
						break;
					}
				}
				if(level>8){
					
		
					this.isFinish=false
					return endPt
				}
				return cycleCheck(source,endPt,level+1)
			}
			return endPt
		}
	
		/**
		 * @private
		 *  评分
		 * @param point
		 * @param endPoint
		 * @return
		 *
		 */
		private function getDis(point:Pt, endPoint:Pt):int
		{
			var dix:int=endPoint.x - point.x
				dix<0?dix=-dix:dix
			var diy:int=endPoint.z - point.z
				diy<0?diy=-diy:diy
			return dix + diy
		}

		private function pass(cell:Cell):Boolean
		{
			var type:int=cell.type;
			if(type==0)return false;
			var t_:int
			mode==1?t_=1:t_=2
			if (type ==t_)
			{
				return true
			}
			
			return false
		}
		
		//获取当前评分最优对象垂直线对象，条件符合将放入开放列表
		private function stratght(tar:Cell,endPoint:Pt,type:String):void
		{
			//如果当前数据模型实例不存在，不进行开放列表的存放，且设置对角方向的开关设定
			if(tar!=null){
				//根据当前寻路模式判断该点是否可通信
				if (pass(tar))
				{
					//可通信时，距离代价在方法内内部的进行，高效与直接调用方法，因此将代价逻辑的计算直接写到方法内内部而不独立写到一个方法中
					//获取当前格子对应的唯一查询键值
					
					var key:String=tar.indexKey
					var pt:Pt=tar.index
					var x:int=pt.x;
					var z:int=pt.z
					var dix:int=endPoint.x - x
					dix<0?dix=-dix:dix
					var diy:int=endPoint.z - z
					diy<0?diy=-diy:diy
					var costH:int= (dix + diy)*10
						
					var costG:int=COST_STRAIGHT+G
					var costF:int=(costG+costH)
					//创建一个节点对象，并制定该对象的父级对象
					var data:AstarData=new AstarData(costG,costF,pt);
					data.parent==null?data.parent=this.nonce:''
					
					//查询开发类表中是否存在该节点
					var openNode:AstarData=openPath[key];
					//查询关闭类表中是否存在该节点
					var colseNode:AstarData=colsePath[key];
					
					if(openNode==null&&colseNode==null){
						//当节点既不存在于开发列表与关闭列表时将其添加到开发列表
						openPath[key]=data
						this.openArray.push(data)
						
					}else if(openNode!=null){
						//当该节点已经存在于开发列表时，
						//判断当前代价，如果当前代价小于之前的代价，则进行数据更新。
						data.F<openNode.F?openPath[key]=data:''
						
					}
					/*
					tl tc tr
					cl    cr
					bl bc br
					*/
				}else {
					//根据当前的数据通信状态对对角方向进行开关设定
					if(type==DIR_TC)
					{
						this.canTC=false;
						this.canTL=false;
						this.canTR=false
					}else if(type==DIR_CT)
					{
						this.canCT=false
						this.canBL=false
						this.canTL=false;
					}else if(type==DIR_CR)
					{
						this.canCR=false
						this.canTR=false
						this.canBR=false
					}else if(type==DIR_BC)
					{
						this.canBC=false
						this.canBR=false
						this.canBL=false
					}
				}
				
			}else {
				//当不存在该格子时，默认为不可通行，对对角方向进行开关设定
				if(type==DIR_TC)
				{
					this.canTC=false;
					this.canTL=false;
					this.canTR=false
				}else if(type==DIR_CT)
				{
					this.canCT=false
				}else if(type==DIR_CR)
				{
					this.canCR=false
				}else if(type==DIR_BC)
				{
					this.canBC=false
				}
			}
			
			
		}
		
		
		//获取当前评分最优对象对角线对象
		private function diagonal(tar:Cell,endPoint:Pt,can:Boolean):void
		{
			//根据can 属性及当前格子是否存在对该格子进行开放列表及关闭列表的存放
			if(can&&tar!=null)
			{
				if(this.pass(tar))
				{
					
					var key:String=tar.indexKey
					var pt:Pt=tar.index;
					var dix:int=endPoint.x - pt.x;
					dix<0?dix=-dix:dix;
					var diy:int=endPoint.z - pt.z;
					diy<0?diy=-diy:diy;
					var costH:int= (dix + diy)*10
					var costG:int=COST_DIAGONAL+G;
					
					var data:AstarData=new AstarData(costG,costG+costH,pt);
					data.parent==null?data.parent=this.nonce:'';
					var openNode:AstarData=openPath[key];
					var colseNode:AstarData=colsePath[key];
					
					if(openNode==null&&colseNode==null)
					{
						openPath[key]=data
						this.openArray.push(data)
					}else if(openNode!=null){
						
						data.F<openNode.F?openPath[key]=data:''
						
					}
				}
			}
			
		}
		//获取当前评分最佳对象
		private function getScale9Grid(source:Dictionary,data:AstarData,endPoint:Pt,breakSetp:int):void
		{
			//每次逸代初始化8方向的开关
			this.canBL=true;
			this.canBR=true;
			this.canTL=true;
			this.canTR=true;
			this.canCT=true;
			this.canCR=true;
			this.canCT=true;
			this.canBC=true;
			//根据当前最小代价节点进行9宫格数据的获取
			var pt:Pt=data.pt
			var x:int=pt.x
			var y:int=pt.z
			
			;
			var _x_:int=x+1
			var _y_:int=y+1
			var x_:int=x-1;
			var y_:int=y-1;
			
			//获取当前节点的9宫格数据模型，
			/*
			tl tc tr
			cl    cr
			bl bc br
			*/
			var tl:Cell=source[x_+'|0|'+y_];
			var tr:Cell=source[_x_+'|0|'+y_];
			var bl:Cell=source[x_+'|0|'+_y_]
			var br:Cell=source[_x_+'|0|'+_y_]
			
			var tc:Cell=source[x+'|0|'+y_];
			var ct:Cell=source[x_+'|0|'+y]
			var cr:Cell=source[_x_+'|0|'+y]
			var bc:Cell=source[x+'|0|'+_y_]
			
//先进行4方向寻路再进行8方向寻路可以提高8方向寻路的效率		
// 水平垂直方向判断，判断时会设定对角方向的开关
			
			//四方向
			if (tc)
				stratght(tc, endPoint, DIR_TC);
			if (ct)
				stratght(ct, endPoint, DIR_CT);
			if (cr)
				stratght(cr, endPoint, DIR_CR);
			if (bc)
				stratght(bc, endPoint, DIR_BC);
			
				
//		根据9宫格对水平垂直方向的对对角方向的开关设定进行	8方向查找
			if (tl)
				diagonal(tl, endPoint, canTL);
			if (tr)
				diagonal(tr, endPoint, canTR);
			if (bl)
				diagonal(bl, endPoint, canBL);
			if (br)
				diagonal(br, endPoint, canBR);
			
			//取下一个最小代价格子
			var len:int=openArray.length
//当条件不符合时跳出寻路			
			if (len==0||(tc == null && ct == null && cr == null && bc == null && tl == null && tr == null && bl == null && br == null))
			{
				this.isFinish=false;
				return
			}
			
			var  data:AstarData
			var index:int=0
//只排序一次，获取最小值
			for(var i:int=0;i<len;i++)
			{
				if(i==0)
				{
					data=openArray[i]
				}else {
					if(openArray[i].F<data.F){
						data=openArray[i];
						index=i
						
					}
				}
			};
				
			this.nonce=data
//因为openArray已经同步删除，故此openPath不在每步中同步删除，改在每次调用重新初始化以减少消耗
//			delete this.openPath[data.key];
			this.openArray.splice(index,1);
			var key:String=this.nonce.key
		//跳出计数，用于防止死循环或者设定了最大遍历次数的寻路方案
			if(this.colsePath[key]==null)
			{
				this.colsePath[key]=this.nonce;
				this.closeLength++
				if (closeLength > breakSetp )this.isFinish=false;
						
			}
			
//找到目标时跳出寻路
			if (this.nonce.key == endPoint.key)
				this.isFinish=false;
			this.G=this.nonce.G;
		}

		//返回最后路径
		private function cleanArray():Array
		{

			this.pathArray=new Array

			var key:String=this.endPoint.key;
			if (this.colsePath[key] == null)
			{
				var min:Number=-1
				
				var pt:Pt;
				var dix:int;
				var diy:int;
				var dis:int
				for each(var o:AstarData in this.colsePath)
				{
					pt=o.pt
					dix=endPoint.x - pt.x
					dix<0?dix=-dix:dix
					diy=endPoint.z - pt.z
					diy<0?diy=-diy:diy
					dis= (dix + diy)
						
						
					if(min==-1){
						min=dis
						key=pt.key
					}else {
						if(dis<min)
						{
							min=dis;
							key=pt.key
						}
					}
				}
				
			}
			var co:AstarData=this.colsePath[key] 
			if (co != null)
			{
				
				this.pathArray.unshift(TileUitls.getIsoIndexMidVertex(co.pt));
				this.pathArray.unshift(TileUitls.getIsoIndexMidVertex(co.parent.pt));
				var run:Boolean=true
				var breakSetp:int=0
				while (run)
				{
					key=this.colsePath[key].parent.key;
					if (key == this.startPoint.key||breakSetp>10000)
					{
						run=false
						break;
					}
					else
					{
						this.pathArray.unshift(TileUitls.getIsoIndexMidVertex(this.colsePath[key].parent.pt))
						breakSetp++
					}
				}

			};
			return this.pathArray
		}

		//  初始化数组	
		private function reSet():void
		{
			this.pathArray=[]
			this.source=new Dictionary
			this.colsePath=new Dictionary;
			this.colseArray=[]
			this.openPath=new Dictionary
			this.openArray=[]
			this.G=0
			this.nonce=null
			this.canTL=true
			this.canTR=true
			this.canBL=true
			this.canBR=true
			this.isFinish=true
			this.closeLength=0
		}
	}
}