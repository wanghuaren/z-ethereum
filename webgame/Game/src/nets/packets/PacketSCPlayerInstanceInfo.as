package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructPlayerInstanceInfo2
    /** 
    *玩家副本信息列表返回
    */
    public class PacketSCPlayerInstanceInfo implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 20002;
        /** 
        *副本信息
        */
        public var arrIteminstanceinfo:Vector.<StructPlayerInstanceInfo2> = new Vector.<StructPlayerInstanceInfo2>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(arrIteminstanceinfo.length);
            for each (var instanceinfoitem:Object in arrIteminstanceinfo)
            {
                var objinstanceinfo:ISerializable = instanceinfoitem as ISerializable;
                if (null!=objinstanceinfo)
                {
                    objinstanceinfo.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrIteminstanceinfo= new  Vector.<StructPlayerInstanceInfo2>();
            var instanceinfoLength:int = ar.readInt();
            for (var iinstanceinfo:int=0;iinstanceinfo<instanceinfoLength; ++iinstanceinfo)
            {
                var objPlayerInstanceInfo:StructPlayerInstanceInfo2 = new StructPlayerInstanceInfo2();
                objPlayerInstanceInfo.Deserialize(ar);
                arrIteminstanceinfo.push(objPlayerInstanceInfo);
            }
        }
    }
}
