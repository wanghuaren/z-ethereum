package scene.load
{
	import comload.JPGLoader;

	import common.config.GameIni;
	import common.config.MapTileResModelConfig;
	import common.config.xmlres.GameData;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.map.MapTileLoader;
	import common.config.xmlres.map.MapTileResModel;
	import common.config.xmlres.server.Pub_MapResModel;

	import engine.utils.Debug;

	import flash.display.*;
	import flash.utils.getTimer;

	import netc.DataKey;

	import scene.action.Action;
	import scene.manager.SceneManager;
	import scene.utils.MapCl;
	import scene.utils.MapData;

	import world.WorldPerformace;
	import world.WorldPoint;

	public class ShowLoadMap extends Sprite
	{
		private static var _instance:ShowLoadMap;

		private var _MAPID:int;

		public function get MAPID():int
		{
			return _MAPID;
		}

		public function set MAPID(value:int):void
		{
			_MAPID=value;
		}

		private var SPArray:Array; // =[];

		//------- 地图二级缓存  begin ---------------------
		private var SPArray1:Array;
		private var SPArray1_MAPID:int=-1;

		private var SPArray2:Array;
		private var SPArray2_MAPID:int=-1;
		//------- 地图二级缓存  end ----------------------
		private var oldXX:int=-1;
		private var oldYY:int=-1;
		private var newXX:int=-1;
		private var newYY:int=-1;


		private var TILE_CONTAINER:Sprite;


		public static function get instance():ShowLoadMap
		{
			if (null == _instance)
			{
				_instance=new ShowLoadMap();
			}

			return _instance;
		}

		public static function hasInstance():Boolean
		{
			if (null == _instance)
			{
				return false;
			}

			return true;

		}

		public function ShowLoadMap():void
		{
			TILE_CONTAINER=MapData.MAP_TILE;
		}

		//
		public function get TILE_W():int
		{
			return MapTileResModelConfig.TILE_WIDTH;
		}

		public function get TILE_H():int
		{
			return MapTileResModelConfig.TILE_HEIGHT;
		}

		//
		public function get PicMaxX():int
		{
			var mapw:int=MapData.MAPW_REAL;
			var _picMaxX:int=int(mapw / TILE_W);

			return _picMaxX;
		}

		public function get PicMaxY():int
		{
			var maph:int=MapData.MAPW_REAL;
			var _picMaxY:int=int(maph / TILE_H);

			return _picMaxY;
		}

		public function hasMapId():Boolean
		{
			if (-1 != SPArray1_MAPID)
			{
				if (SPArray1_MAPID == MAPID)
				{
					return true;
				}

			}

			if (-1 != SPArray2_MAPID)
			{
				if (SPArray2_MAPID == MAPID)
				{
					return true;
				}
			}

			return false;
		}


		public function LoadAndUpdate():void
		{

			//清除
			removePICArray();

			//置MAPID
			//在对MapData.MAPID的赋值中，也有对本类这个MAPID的赋值中
			MAPID=MapData.MAPID;

			if (GameData.OPEN)
			{
				if (GameData.B_OPEN)
				{
					if (-1 == SPArray1_MAPID && -1 == SPArray2_MAPID)
					{
						//第一次进入地图
						SPArray1_MAPID=MAPID;
						SPArray1=SPArray=[];

					}
					else if (hasMapId())
					{
						//A,B地图间切换
						if (-1 != SPArray1_MAPID && SPArray1_MAPID == MAPID)
						{
							SPArray=SPArray1;

						}
						else if (-1 != SPArray2_MAPID && SPArray2_MAPID == MAPID)
						{
							SPArray=SPArray2;
						}

						//
						GameData.resetAllMapTileLoader();
						//
//						MapCl.GC();

					}
					else if (-1 != SPArray1_MAPID && -1 == SPArray2_MAPID)
					{
						//第一次切换地图	
						SPArray2_MAPID=MAPID;
						SPArray2=SPArray=[];

						//
						GameData.resetAllMapTileLoader();
						//
//						MapCl.GC();

					}
					else
					{
						//B,C地图间切换
						//removePICArray();//上面已执行removePic
						GameData.resetAllMapTileLoader();
						removeMapTileResModelByspArr(SPArray1);

						//
						SPArray1_MAPID=SPArray2_MAPID;
						SPArray1=SPArray2;
						//
						SPArray2_MAPID=MAPID;
						SPArray2=SPArray=[];

						//
//						MapCl.GC();

					}
				} //end if
			}

			//MapData.mapx=MapData.mapy=0;
			//MapData.GAME_MAP.x=MapData.GAME_MAP.y=0;
			//老项目9999太小，已不适用
			oldXX=oldYY=99999;
		}



		public function mapmove():void
		{
			SceneManager.instance.reloadTile();
			return;
			if (0 == MAPID)
			{
				return;
			}

			if (MAPID != SceneManager.instance.currentMapId)
			{
				return;
			}

			//进游戏时忽略sleep
			if (-1 != this.SPArray1_MAPID && -1 != this.SPArray2_MAPID)
			{
				if (DataKey.instance.firstRecvPlayerData)
				{
					if (DataKey.instance.sleep)
					{
						return;
					}
				}
			}


			var w:int=GameIni.MAP_SIZE_W + TILE_W;
			var h:int=GameIni.MAP_SIZE_H + TILE_H;



			var m_x:int;
			var m_y:int;

			//			
			if (WorldPerformace.USE_ABSOLUTE_POINT)
			{
				m_x=Math.ceil(MapData.GAME_MAP.x);
				m_y=Math.ceil(MapData.GAME_MAP.y);

			}
			else
			{
				m_x=Math.ceil(MapData.mapx);
				m_y=Math.ceil(MapData.mapy);
			}

			var x2:Number=Math.abs(m_x) / TILE_W;
			var y2:Number=Math.abs(m_y) / TILE_H;

			var newXX2:int;
			var newYY2:int;

			var oldXX2:int=oldXX;
			var oldYY2:int=oldYY;

			//保守
			newXX2=newXX=Math.floor(x2) - 1;
			newYY2=newYY=Math.floor(y2) - 1;

			if (newXX == oldXX && newYY == oldYY && !Action.instance.yuJianFly.fly)
			{
				return;
			}

			oldXX=newXX;
			oldYY=newYY;

			//因为newXX是保守的，Math.ceil刚刚好，因此这里还要加2，左边一个，右边一个
			//var mxx:int=Math.ceil(w / TILE_W) + 2;
			//var mxy:int=Math.ceil(h / TILE_H) + 2;

			var mxx:int=Math.ceil(w / TILE_W);
			var mxy:int=Math.ceil(h / TILE_H);

			//地图缩放，需多加载
			if (Action.instance.yuJianFly.fly)
			{
				//假设0.5的比率
				mxx+=2;
				mxy+=2;

			}
			else
			{
				mxx+=1;
				mxy+=1;
			}

			var Count:int;

			var j:int;
			var k:int;

			//-2是左，mxx是右，环绕加载地图切片
			if (Action.instance.yuJianFly.fly)
			{
				//----------------------------
				for (j=-2; j < mxx; j++)
				{
					for (k=-2; k < mxy; k++)
					{
						addTile(newXX + j, newYY + k);
						Count++;
					}
				}


			}
			else
			{
				//----------------------------
				for (j=-1; j < mxx; j++)
				{
					for (k=-1; k < mxy; k++)
					{
						addTile(newXX + j, newYY + k);
						Count++;
					}
				}



			}




			// for(xx=-3;xx<4;xx++){
			// for(yy=-3;yy<4;yy++){
			// addTile(newXX+xx,newYY+yy);
			// Count++;
			// }
			// }
			// ************************
			//Debug.instance.traceMsg("使用 " + Count.toString() + " 个loader");
			var num:int;

			if (GameData.OPEN)
			{
				///////////////////////////////////////////////////////////////////////////
				//fux_map
				if (TILE_CONTAINER.numChildren >= Count)
				{
					num=TILE_CONTAINER.numChildren - Count;
				}
				else
				{
					num=0;
				}



				var d:DisplayObject;
				var _loader:MapTileLoader;
				for (var i:int=0; i < num; i++)
				{
					//map.removeChildAt(0);
					d=TILE_CONTAINER.removeChildAt(0);

					if (d is MapTileResModel)
					{
						//(d as MapTileResModel).setEnableDestoryPlus();		

						//(d as MapTileResModel).destory();

						//移除不必要的加载
						_loader=(d as MapTileResModel)._loader;

						if (null != _loader)
						{
							if (_loader.isCanStartLoad)
							{
								_loader.loadCancel();
							}
						} //

					} //end if
				} //end for


					//


					//Debug.instance.traceMsg("计数费时:" + (getTimer() - oldTime));
					////////////////////////////////////////////////////////////////////////////

			}
			else
			{
				num=TILE_CONTAINER.numChildren - Count;
				for (var n:int=0; n < num; n++)
					TILE_CONTAINER.removeChildAt(0);

			}

			//Debug.instance.traceMsg("费时:" + (getTimer() - oldTime));
		}

		private function addTile(nx:int, ny:int):void
		{
			//if(MAPID==null) return;
			if (nx < 0 || ny < 0 || nx > PicMaxX || ny > PicMaxY)
				return;

			//var oldTime:int=getTimer();

			//var model:Pub_MapResModel = XmlManager.localres.getPubMapXml.getResPath(SceneManager.instance.currentMapId);

			var mapResModel:Pub_MapResModel=XmlManager.localres.getPubMapXml.getResPath(SceneManager.instance.currentMapId) as Pub_MapResModel;

			var url:String=GameIni.GAMESERVERS + "Map/BigMap/" + mapResModel.res_id.toString() + "/" + nx + "_" + ny + ".jpg?" + GameIni.MAP_VER;
			var bLoader:MapTileLoader;
			var tile:MapTileResModel;

			var needLoad:Boolean=false;

			if (SPArray.hasOwnProperty(nx) && SPArray[nx].hasOwnProperty(ny))
			{
				//Debug.instance.traceMsg(SPArray[nx][ny]);
				if ("destory" == SPArray[nx][ny] || null == SPArray[nx][ny])
				{
					needLoad=true;
				}

				if (!needLoad)
				{
					tile=SPArray[nx][ny] as MapTileResModel;

					if (tile.check())
					{
						tile.destory();
						tile=null;
						SPArray[nx][ny]=null;
						needLoad=true;
					}
				}

			}
			else
			{
				needLoad=true;
			}

			if (needLoad)
			{
				bLoader=GameData.getMapTileLoader();

				var tw_nx:int=TILE_W * nx;
				var th_ny:int=TILE_H * ny;

				tile=new MapTileResModel(GameMosaicMap.getBitMapData(tw_nx, th_ny), nx, ny);

				if (WorldPerformace.USE_ABSOLUTE_POINT)
				{
					tile.x=tw_nx;
					tile.y=th_ny;

				}
				else
				{
					var p:WorldPoint=MapCl.getAbsoluteDistance(tw_nx, th_ny);
					tile.x=p.x;
					tile.y=p.y;
				}

				bLoader.loadReady(url, tile);

				if (!SPArray.hasOwnProperty(nx))
					SPArray[nx]=[];
				SPArray[nx][ny]=tile;
				GameData.runMapTileLoaderTaskList();

			}
			else
			{
				tile=SPArray[nx][ny] as MapTileResModel;

			}
			//new codes
			TILE_CONTAINER.addChild(tile);
			//Debug.instance.traceMsg("费时:" + (getTimer() - oldTime));
		}

		private function removeMapTileResModelByspArr(spArr:Array):void
		{
			if (null == spArr)
				return;

			if (spArr.length > 0)
			{
				try
				{
					var len:int=spArr.length;
					var len2:int;
					var sp2:Array;
					var m:MapTileResModel;
					var j:int;
					var k:int;

					for (j=0; j < len; j++)
					{
						sp2=spArr[j] as Array;

						if (null == sp2)
						{
							continue;
						}
						if ("undefined" == sp2.toString())
						{
							continue;
						}

						len2=sp2.length;

						for (k=0; k < len2; k++)
						{
							if (null == spArr[j][k])
							{
								continue;
							}
							if ("undefined" == spArr[j][k].toString())
							{
								continue;
							}
							if ("destory" == spArr[j][k].toString())
							{
								continue;
							}

							if (spArr[j][k] is MapTileResModel)
							{
								m=spArr[j][k] as MapTileResModel;
								//m.setEnableDestoryPlus();	

								//if(m.isEnableDestoryMax())
								//{
								//spArr[j][k] = "destory";
								m.destory();

								spArr[j][k]=null; // 使对象能够进行垃圾回收。

									//Debug.instance.traceMsg(j,",",k,":destory");
									//}
									//Debug.instance.traceMsg("销毁地图块: " + j.toString() + " , " + k.toString());
							}
						} //end for						
					} //end for		
				}
				catch (err:Error)
				{
					Debug.instance.traceMsg(err.message + " func:spArr.length > 0");
				}
			} //end if

		}

		private function removePICArray():void
		{

			//if(GameData.OPEN)
			//{
			//	removeMapTileResModelBySPArray();
			//}

			//SPArray=[];

			//
			if (GameData.OPEN)
			{
				var d:DisplayObject;

				while (TILE_CONTAINER.numChildren)
				{
					d=TILE_CONTAINER.removeChildAt(0);
				}

				if (GameData.B_OPEN)
				{


				}
				else
				{
					removeMapTileResModelByspArr(SPArray);
					SPArray=[];
					GameData.resetAllMapTileLoader();
//					MapCl.GC();
				}

			}
			else
			{
				while (TILE_CONTAINER.numChildren)
				{
					if (TILE_CONTAINER.getChildAt(0) is JPGLoader)
						(TILE_CONTAINER.getChildAt(0) as JPGLoader).unload();
					TILE_CONTAINER.removeChildAt(0);
				}

				SPArray=[];
//				MapCl.GC();
			}


		}
	}
}
