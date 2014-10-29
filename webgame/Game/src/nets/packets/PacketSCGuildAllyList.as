package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructGuildPlayerAllyInfoItem2
    /** 
    *获取公会结盟列表
    */
    public class PacketSCGuildAllyList implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 39252;
        /** 
        *结盟列表
        */
        public var arrItemlist:Vector.<StructGuildPlayerAllyInfoItem2> = new Vector.<StructGuildPlayerAllyInfoItem2>();

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
            arrItemlist= new  Vector.<StructGuildPlayerAllyInfoItem2>();
            var listLength:int = ar.readInt();
            for (var ilist:int=0;ilist<listLength; ++ilist)
            {
                var objGuildPlayerAllyInfoItem:StructGuildPlayerAllyInfoItem2 = new StructGuildPlayerAllyInfoItem2();
                objGuildPlayerAllyInfoItem.Deserialize(ar);
                arrItemlist.push(objGuildPlayerAllyInfoItem);
            }
        }
    }
}
