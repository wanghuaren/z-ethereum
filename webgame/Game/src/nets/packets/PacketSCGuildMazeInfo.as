package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructGuildMazePlayerInfo2
    /** 
    *帮派迷宫更新
    */
    public class PacketSCGuildMazeInfo implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 29113;
        /** 
        *排名
        */
        public var index:int;
        /** 
        *积分
        */
        public var point:int;
        /** 
        *积分排行
        */
        public var arrItemranks:Vector.<StructGuildMazePlayerInfo2> = new Vector.<StructGuildMazePlayerInfo2>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(index);
            ar.writeInt(point);
            ar.writeInt(arrItemranks.length);
            for each (var ranksitem:Object in arrItemranks)
            {
                var objranks:ISerializable = ranksitem as ISerializable;
                if (null!=objranks)
                {
                    objranks.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            index = ar.readInt();
            point = ar.readInt();
            arrItemranks= new  Vector.<StructGuildMazePlayerInfo2>();
            var ranksLength:int = ar.readInt();
            for (var iranks:int=0;iranks<ranksLength; ++iranks)
            {
                var objGuildMazePlayerInfo:StructGuildMazePlayerInfo2 = new StructGuildMazePlayerInfo2();
                objGuildMazePlayerInfo.Deserialize(ar);
                arrItemranks.push(objGuildMazePlayerInfo);
            }
        }
    }
}
