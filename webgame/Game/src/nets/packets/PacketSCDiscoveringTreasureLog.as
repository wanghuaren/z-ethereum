package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructGetItemLog2
    /** 
    *全服寻宝史册
    */
    public class PacketSCDiscoveringTreasureLog implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 43206;
        /** 
        *缓存版本号
        */
        public var version:int;
        /** 
        *寻宝信息
        */
        public var arrItemlog:Vector.<StructGetItemLog2> = new Vector.<StructGetItemLog2>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(version);
            ar.writeInt(arrItemlog.length);
            for each (var logitem:Object in arrItemlog)
            {
                var objlog:ISerializable = logitem as ISerializable;
                if (null!=objlog)
                {
                    objlog.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            version = ar.readInt();
            arrItemlog= new  Vector.<StructGetItemLog2>();
            var logLength:int = ar.readInt();
            for (var ilog:int=0;ilog<logLength; ++ilog)
            {
                var objGetItemLog:StructGetItemLog2 = new StructGetItemLog2();
                objGetItemLog.Deserialize(ar);
                arrItemlog.push(objGetItemLog);
            }
        }
    }
}
