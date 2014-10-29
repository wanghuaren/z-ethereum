package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *pk无双奖励信息
    */
    public class PacketSCPKOnePrize implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 29063;
        /** 
        *胜利失败 0 失败 1 胜利
        */
        public var iswin:int;
        /** 
        *杀死玩家数
        */
        public var kill_num:int;
        /** 
        *伤害
        */
        public var damage:int;
        /** 
        *获得经验
        */
        public var exp:int;
        /** 
        *获得银两
        */
        public var coin:int;
        /** 
        *获得声望
        */
        public var renown:int;
        /** 
        *获得元宝
        */
        public var rmb:int;
        /** 
        *存活时间
        */
        public var lifetime:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(iswin);
            ar.writeInt(kill_num);
            ar.writeInt(damage);
            ar.writeInt(exp);
            ar.writeInt(coin);
            ar.writeInt(renown);
            ar.writeInt(rmb);
            ar.writeInt(lifetime);
        }
        public function Deserialize(ar:ByteArray):void
        {
            iswin = ar.readInt();
            kill_num = ar.readInt();
            damage = ar.readInt();
            exp = ar.readInt();
            coin = ar.readInt();
            renown = ar.readInt();
            rmb = ar.readInt();
            lifetime = ar.readInt();
        }
    }
}
