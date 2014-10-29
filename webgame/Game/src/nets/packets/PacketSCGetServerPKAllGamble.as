package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructServerPlayerPkGambleInfo2
    /** 
    *获得玩家所有押注信息返回
    */
    public class PacketSCGetServerPKAllGamble implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 40014;
        /** 
        *押注信息列表
        */
        public var arrItemmanlist:Vector.<StructServerPlayerPkGambleInfo2> = new Vector.<StructServerPlayerPkGambleInfo2>();

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
            arrItemmanlist= new  Vector.<StructServerPlayerPkGambleInfo2>();
            var manlistLength:int = ar.readInt();
            for (var imanlist:int=0;imanlist<manlistLength; ++imanlist)
            {
                var objServerPlayerPkGambleInfo:StructServerPlayerPkGambleInfo2 = new StructServerPlayerPkGambleInfo2();
                objServerPlayerPkGambleInfo.Deserialize(ar);
                arrItemmanlist.push(objServerPlayerPkGambleInfo);
            }
        }
    }
}
