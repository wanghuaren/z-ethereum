package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructHeroGetItemLog2
    /** 
    *个人寻宝日志
    */
    public class PacketSCDiscoveringTreasureHeroLog implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 43207;
        /** 
        *寻宝信息
        */
        public var arrItemlog:Vector.<StructHeroGetItemLog2> = new Vector.<StructHeroGetItemLog2>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
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
            arrItemlog= new  Vector.<StructHeroGetItemLog2>();
            var logLength:int = ar.readInt();
            for (var ilog:int=0;ilog<logLength; ++ilog)
            {
                var objHeroGetItemLog:StructHeroGetItemLog2 = new StructHeroGetItemLog2();
                objHeroGetItemLog.Deserialize(ar);
                arrItemlog.push(objHeroGetItemLog);
            }
        }
    }
}
