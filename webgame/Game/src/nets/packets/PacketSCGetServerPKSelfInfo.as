package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructServerPlayerPkSelfInfo2
    /** 
    *获得玩家战绩信息返回
    */
    public class PacketSCGetServerPKSelfInfo implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 40016;
        /** 
        *战绩信息列表
        */
        public var arrItemmanlist:Vector.<StructServerPlayerPkSelfInfo2> = new Vector.<StructServerPlayerPkSelfInfo2>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(arrItemmanlist.length);
            for each (var manlistitem:Object in arrItemmanlist)
            {
                var objmanlist:ISerializable = manlistitem as ISerializable;
                if (null!=objmanlist)
                {
                    objmanlist.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemmanlist= new  Vector.<StructServerPlayerPkSelfInfo2>();
            var manlistLength:int = ar.readInt();
            for (var imanlist:int=0;imanlist<manlistLength; ++imanlist)
            {
                var objServerPlayerPkSelfInfo:StructServerPlayerPkSelfInfo2 = new StructServerPlayerPkSelfInfo2();
                objServerPlayerPkSelfInfo.Deserialize(ar);
                arrItemmanlist.push(objServerPlayerPkSelfInfo);
            }
        }
    }
}
