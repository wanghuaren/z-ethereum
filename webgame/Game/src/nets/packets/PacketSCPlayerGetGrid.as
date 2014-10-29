package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructGridPlayerInfo2
    /** 
    *返回角色附近玩家列表
    */
    public class PacketSCPlayerGetGrid implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 1005;
        /** 
        *角色列表
        */
        public var arrItemGridPlayerInfo:Vector.<StructGridPlayerInfo2> = new Vector.<StructGridPlayerInfo2>();
        /** 
        *当前第几页
        */
        public var curpage:int;
        /** 
        *总共页数
        */
        public var totalpage:int;
        /** 
        *只显示未组队玩家，1只显示，0不显示，2表示好友附近玩家请求
        */
        public var noteam:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(arrItemGridPlayerInfo.length);
            for each (var GridPlayerInfoitem:Object in arrItemGridPlayerInfo)
            {
                var objGridPlayerInfo:ISerializable = GridPlayerInfoitem as ISerializable;
                if (null!=objGridPlayerInfo)
                {
                    objGridPlayerInfo.Serialize(ar);
                }
            }
            ar.writeInt(curpage);
            ar.writeInt(totalpage);
            ar.writeInt(noteam);
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemGridPlayerInfo= new  Vector.<StructGridPlayerInfo2>();
            var GridPlayerInfoLength:int = ar.readInt();
            for (var iGridPlayerInfo:int=0;iGridPlayerInfo<GridPlayerInfoLength; ++iGridPlayerInfo)
            {
                var objGridPlayerInfo:StructGridPlayerInfo2 = new StructGridPlayerInfo2();
                objGridPlayerInfo.Deserialize(ar);
                arrItemGridPlayerInfo.push(objGridPlayerInfo);
            }
            curpage = ar.readInt();
            totalpage = ar.readInt();
            noteam = ar.readInt();
        }
    }
}
