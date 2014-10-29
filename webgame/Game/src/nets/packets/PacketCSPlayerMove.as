package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructWayPoint2
    /** 
    *客户端移动
    */
    public class PacketCSPlayerMove implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 11001;
        /** 
        *地图id
        */
        public var mapid:int;
        /** 
        *客户端移动列表
        */
        public var arrItemway_point:Vector.<StructWayPoint2> = new Vector.<StructWayPoint2>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(mapid);
            ar.writeInt(arrItemway_point.length);
            for each (var way_pointitem:Object in arrItemway_point)
            {
                var objway_point:ISerializable = way_pointitem as ISerializable;
                if (null!=objway_point)
                {
                    objway_point.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            mapid = ar.readInt();
            arrItemway_point= new  Vector.<StructWayPoint2>();
            var way_pointLength:int = ar.readInt();
            for (var iway_point:int=0;iway_point<way_pointLength; ++iway_point)
            {
                var objWayPoint:StructWayPoint2 = new StructWayPoint2();
                objWayPoint.Deserialize(ar);
                arrItemway_point.push(objWayPoint);
            }
        }
    }
}
