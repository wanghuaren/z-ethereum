package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructServerPKMatchInfo2
    /** 
    *获得仙道会举行的界数信息返回
    */
    public class PacketSCGetServerPKTotalList implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 53048;
        /** 
        *所有的界数信息
        */
        public var arrItemno_list:Vector.<StructServerPKMatchInfo2> = new Vector.<StructServerPKMatchInfo2>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(arrItemno_list.length);
            for each (var no_listitem:Object in arrItemno_list)
            {
                var objno_list:ISerializable = no_listitem as ISerializable;
                if (null!=objno_list)
                {
                    objno_list.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemno_list= new  Vector.<StructServerPKMatchInfo2>();
            var no_listLength:int = ar.readInt();
            for (var ino_list:int=0;ino_list<no_listLength; ++ino_list)
            {
                var objServerPKMatchInfo:StructServerPKMatchInfo2 = new StructServerPKMatchInfo2();
                objServerPKMatchInfo.Deserialize(ar);
                arrItemno_list.push(objServerPKMatchInfo);
            }
        }
    }
}
