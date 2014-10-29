package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructSeekList2
    /** 
    *地图寻路列表
    */
    public class PacketSCNpcSeek implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 13008;
        /** 
        *
        */
        public var arrItemlist:Vector.<StructSeekList2> = new Vector.<StructSeekList2>();

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
            arrItemlist= new  Vector.<StructSeekList2>();
            var listLength:int = ar.readInt();
            for (var ilist:int=0;ilist<listLength; ++ilist)
            {
                var objSeekList:StructSeekList2 = new StructSeekList2();
                objSeekList.Deserialize(ar);
                arrItemlist.push(objSeekList);
            }
        }
    }
}
