package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructSignPlayerInfo2
    /** 
    *玩家副本报名数据
    */
    public class StructSignList implements ISerializable
    {
        /** 
        *副本id
        */
        public var instanceid:int;
        /** 
        *报名id
        */
        public var signid:int;
        /** 
        *进入方式 0-3人进入 1-4人进入 2-5人进入 3-手动进入
        */
        public var entertype:int;
        /** 
        *玩家信息列表
        */
        public var arrItemplayerlist:Vector.<StructSignPlayerInfo2> = new Vector.<StructSignPlayerInfo2>();

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(instanceid);
            ar.writeInt(signid);
            ar.writeInt(entertype);
            ar.writeInt(arrItemplayerlist.length);
            for each (var playerlistitem:Object in arrItemplayerlist)
            {
                var objplayerlist:ISerializable = playerlistitem as ISerializable;
                if (null!=objplayerlist)
                {
                    objplayerlist.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            instanceid = ar.readInt();
            signid = ar.readInt();
            entertype = ar.readInt();
            arrItemplayerlist= new  Vector.<StructSignPlayerInfo2>();
            var playerlistLength:int = ar.readInt();
            for (var iplayerlist:int=0;iplayerlist<playerlistLength; ++iplayerlist)
            {
                var objSignPlayerInfo:StructSignPlayerInfo2 = new StructSignPlayerInfo2();
                objSignPlayerInfo.Deserialize(ar);
                arrItemplayerlist.push(objSignPlayerInfo);
            }
        }
    }
}
