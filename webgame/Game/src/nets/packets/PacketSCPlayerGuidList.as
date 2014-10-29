package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructPlayerGuidInfo2
    /** 
    *玩家引导信息返回
    */
    public class PacketSCPlayerGuidList implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 15025;
        /** 
        *引导信息列表
        */
        public var arrItemlist:Vector.<StructPlayerGuidInfo2> = new Vector.<StructPlayerGuidInfo2>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(arrItemlist.length);
            for each (var listitem:Object in arrItemlist)
            {
                var objlist:ISerializable = listitem as ISerializable;
                if (null!=objlist)
                {
                    objlist.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemlist= new  Vector.<StructPlayerGuidInfo2>();
            var listLength:int = ar.readInt();
            for (var ilist:int=0;ilist<listLength; ++ilist)
            {
                var objPlayerGuidInfo:StructPlayerGuidInfo2 = new StructPlayerGuidInfo2();
                objPlayerGuidInfo.Deserialize(ar);
                arrItemlist.push(objPlayerGuidInfo);
            }
        }
    }
}
