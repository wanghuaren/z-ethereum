package com.engine.core.tile.square
{
	import com.engine.namespaces.saiman;
	import com.engine.utils.Hash;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;

	/**
	 * 
	 * @author saiman
	 * 2012-5-31-下午2:13:29
	 */
	public class SquareGroup
	{
		private static var instance:SquareGroup
		private var quene:Array
		private  var $hash:Hash;
		public function SquareGroup()
		{
			if(instance==null){
				
				instance=this;
				initialize()
				if(this.$hash)
				{
					this.quene=[]
					this.$hash.dispose();
					this.$hash=new Hash;
					
				}
			}
		}
		
		
		saiman function get quene():Array
		{
			return quene
		}
		public function get hash():Hash
		{
			return $hash;
		}
		
		public static  function  getInstance():SquareGroup
		{
			if(instance==null)instance=new SquareGroup;
			
			return instance
		}
		public function dispose():void
		{
			$hash.dispose()
			$hash=null
			this.quene=null
		}
		public function initialize():void
		{
			$hash=new Hash
			this.quene=[]
		
		}
		
		public function unload():void	
		{
			if (this.hash == null)
				return;
			try
			{
				for (var i:String in this.hash.hash)
				{
					var sq:Square=this.hash.hash[i];
					sq.dispose();
					delete this.hash.hash[i]
				}
				this.$hash=null
			}
		
			catch (e:Error)
			{
				
			}
			this.quene=null
			instance=null
		}
		
		public function reset(source:Dictionary):void
		{
			var hash:Hash=$hash
			this.$hash=null
			this.$hash=new Hash;
			this.quene=[]
			for each (var i:Square in source)
			{
				this.put(i)
			}
			hash.dispose()
		}
		
		public function put(value:Square):void
		{
			if(hash.has(value.key)==false){
				quene.push(value)
			}
			this.hash.put(value.key,value)
			
		}
		
		public function remove(key:String):Square
		{
			if (this.hash.has(key))
			{
				var cell:Square=this.$hash.remove(key) as Square;
				var index:int=quene.indexOf(cell)
				if(index!=-1)
				{
					quene.splice(index,1)
				}
				return cell 
			}
			
			return null
		}
		public function has(key:String):Boolean
		{
			if (key == null)
				return false;
			return this.hash.has(key)
		}
		
		public function take(key:String):Square
		{
			return this.$hash.take(key) as Square;
		}

		
		public function passAbled (pt:SquarePt):Boolean
		{
			
			if(pt){
				var cell:Square=this.$hash.take(pt.key) as Square
				if(cell){
					if(cell.type==3||cell.type==4)
					{
						if(cell.type>0)return true;
						
					}else {
						//						if(cell.empty>0)return true;
						
					}
				}
			}
			return false
		}
		
		
		
		
		
		
	}
}