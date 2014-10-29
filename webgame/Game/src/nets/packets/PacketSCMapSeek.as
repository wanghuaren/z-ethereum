package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructMapSeek2
    /** 
    *地图传送点列表
    */
    public class PacketSCMapSeek implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 13002;
        /** 
        *传送点列表
        */
        public var arrItemlist:Vector.<StructMapSeek2> = new Vector.<StructMapSeek2>();

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
            arrItemlist= new  Vector.<StructMapSeek2>();
            var listLength:int = ar.readInt();
            for (var ilist:int=0;ilist<listLength; ++ilist)
            {
                var objMapSeek:StructMapSeek2 = new StructMapSeek2();
                objMapSeek.Deserialize(ar);
                arrItemlist.push(objMapSeek);
            }
        }
    }
}
