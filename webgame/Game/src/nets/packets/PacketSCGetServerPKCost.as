package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructServerPlayerPkCostInfo2
    /** 
    *获得玩家身价信息返回
    */
    public class PacketSCGetServerPKCost implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 40018;
        /** 
        *身价信息列表
        */
        public var arrItemmanlist:Vector.<StructServerPlayerPkCostInfo2> = new Vector.<StructServerPlayerPkCostInfo2>();

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
            arrItemmanlist= new  Vector.<StructServerPlayerPkCostInfo2>();
            var manlistLength:int = ar.readInt();
            for (var imanlist:int=0;imanlist<manlistLength; ++imanlist)
            {
                var objServerPlayerPkCostInfo:StructServerPlayerPkCostInfo2 = new StructServerPlayerPkCostInfo2();
                objServerPlayerPkCostInfo.Deserialize(ar);
                arrItemmanlist.push(objServerPlayerPkCostInfo);
            }
        }
    }
}
