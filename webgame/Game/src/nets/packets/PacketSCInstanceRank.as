package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructInstanceRankPlayerInfo2
    /** 
    *副本排行榜数据返回
    */
    public class PacketSCInstanceRank implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 29029;
        /** 
        *副本标识,1表示四神器1,2表示四神器2,3表示四神器3,4表示四神器4,5表示魔天万界
        */
        public var instanceid:int;
        /** 
        *副本数据列表
        */
        public var arrItemlist:Vector.<StructInstanceRankPlayerInfo2> = new Vector.<StructInstanceRankPlayerInfo2>();
        /** 
        *个人排名
        */
        public var index:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(instanceid);
            ar.writeInt(arrItemlist.length);
            for each (var listitem:Object in arrItemlist)
            {
                var objlist:ISerializable = listitem as ISerializable;
                if (null!=objlist)
                {
                    objlist.Serialize(ar);
                }
            }
            ar.writeInt(index);
        }
        public function Deserialize(ar:ByteArray):void
        {
            instanceid = ar.readInt();
            arrItemlist= new  Vector.<StructInstanceRankPlayerInfo2>();
            var listLength:int = ar.readInt();
            for (var ilist:int=0;ilist<listLength; ++ilist)
            {
                var objInstanceRankPlayerInfo:StructInstanceRankPlayerInfo2 = new StructInstanceRankPlayerInfo2();
                objInstanceRankPlayerInfo.Deserialize(ar);
                arrItemlist.push(objInstanceRankPlayerInfo);
            }
            index = ar.readInt();
        }
    }
}
