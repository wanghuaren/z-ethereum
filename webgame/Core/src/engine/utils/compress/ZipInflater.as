package engine.utils.compress {
	import flash.utils.Endian;
	import flash.utils.ByteArray;

	internal class ZipInflater {
		private static const MAXBITS : int = 15; 
		private static const MAXLCODES : int = 286;
		private static const MAXDCODES : int = 30;
		//private static const MAXCODES:int = MAXLCODES + MAXDCODES;
		private static const FIXLCODES : int = 288; 
		private static const LENS : Array = [3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 15, 17, 19, 23, 27, 31, 35, 43, 51, 59, 67, 83, 99, 115, 131, 163, 195, 227, 258];
		private static const LEXT : Array = [0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 0];
		private static const DISTS : Array = [1, 2, 3, 4, 5, 7, 9, 13, 17, 25, 33, 49, 65, 97, 129, 193, 257, 385, 513, 769, 1025, 1537, 2049, 3073, 4097, 6145, 8193, 12289, 16385, 24577];
		private static const DEXT : Array = [0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13];
		private var inbuf : ByteArray;
		private var incnt : uint;
		private var bitbuf : int; 
		private var bitcnt : int;
		private var lencode : Object;
		private var distcode : Object;

		internal function setInput(buf : ByteArray) : void {
			inbuf = buf;
			inbuf.endian = Endian.LITTLE_ENDIAN;
		}

		internal function inflate(buf : ByteArray) : uint {
			incnt = bitbuf = bitcnt = 0;
			var err : int = 0;
			do {
				var last : int = bits(1);
				var type : int = bits(2);
				if(type == 0) stored(buf);
				else if(type == 3) throw new Error('Error', -1); else {
					lencode = {count:[], symbol:[]};
					distcode = {count:[], symbol:[]};
					if(type == 1) constructFixedTables();
					else if(type == 2) err = constructDynamicTables();
					if(err != 0) return err;
					err = codes(buf);
				}
				if(err != 0) break;
			} while(!last);
			return err;
		}

		private function bits(need : int) : int {
			var val : int = bitbuf;
			while(bitcnt < need) {
				if (incnt == inbuf.length) throw new Error('Error', 2);
				val |= inbuf[incnt++] << bitcnt; 
				bitcnt += 8;
			}
			bitbuf = val >> need;
			bitcnt -= need;
			return val & ((1 << need) - 1);
		}

		private function construct(h : Object, length : Array, n : int) : int {
			var offs : Array = []; 
			for(var len : int = 0;len <= MAXBITS; len++) h.count[len] = 0;
			for(var symbol : int = 0;symbol < n; symbol++) h.count[length[symbol]]++;
			if(h.count[0] == n) return 0;
			var left : int = 1;
			for(len = 1;len <= MAXBITS; len++) {
				left <<= 1; 
				left -= h.count[len]; 
				if(left < 0) return left; 
			}
			offs[1] = 0;
			for(len = 1;len < MAXBITS; len++) offs[len + 1] = offs[len] + h.count[len];
			for(symbol = 0;symbol < n; symbol++)
				if(length[symbol] != 0) h.symbol[offs[length[symbol]]++] = symbol;
			return left;
		}

		private function decode(h : Object) : int {
			var code : int = 0; 
			var first : int = 0; 
			var index : int = 0; 
			for(var len : int = 1;len <= MAXBITS; len++) { 
				code |= bits(1); 
				var count : int = h.count[len];
				if(code < first + count) return h.symbol[index + (code - first)];
				index += count; 
				first += count;
				first <<= 1;
				code <<= 1;
			}
			return -9; 
		}

		private function codes(buf : ByteArray) : int {
			do {
				var symbol : int = decode(lencode);
				if(symbol < 0) return symbol; 
				if(symbol < 256) buf[buf.length] = symbol; 
				else if(symbol > 256) { 
					symbol -= 257;
					if(symbol >= 29) throw new Error("Error", -9);
					var len : int = LENS[symbol] + bits(LEXT[symbol]); 
					symbol = decode(distcode);
					if(symbol < 0) return symbol; 
					var dist : uint = DISTS[symbol] + bits(DEXT[symbol]); 
					if(dist > buf.length) throw new Error("Error", -10);
					while(len--) buf[buf.length] = buf[buf.length - dist];
				}
			} while (symbol != 256);
			return 0; 
		}

		private function stored(buf : ByteArray) : void {
			bitbuf = 0;
			bitcnt = 0;
			if(incnt + 4 > inbuf.length) throw new Error('Error', 2);
			var len : uint = inbuf[incnt++]; 
			len |= inbuf[incnt++] << 8;
			if(inbuf[incnt++] != (~len & 0xff) || inbuf[incnt++] != ((~len >> 8) & 0xff))
				throw new Error("Error", -2);
			if(incnt + len > inbuf.length) throw new Error('Error', 2);
			while(len--) buf[buf.length] = inbuf[incnt++]; 
		}

		private function constructFixedTables() : void {
			var lengths : Array = [];
			for(var symbol : int = 0;symbol < 144; symbol++) lengths[symbol] = 8;
			for(;symbol < 256; symbol++) lengths[symbol] = 9;
			for(;symbol < 280; symbol++) lengths[symbol] = 7;
			for(;symbol < FIXLCODES; symbol++) lengths[symbol] = 8;
			construct(lencode, lengths, FIXLCODES);
			for(symbol = 0;symbol < MAXDCODES; symbol++) lengths[symbol] = 5;
			construct(distcode, lengths, MAXDCODES);
		}

		private function constructDynamicTables() : int {
			var lengths : Array = []; 
			var order : Array = [16, 17, 18, 0, 8, 7, 9, 6, 10, 5, 11, 4, 12, 3, 13, 2, 14, 1, 15];
			var nlen : int = bits(5) + 257;
			var ndist : int = bits(5) + 1;
			var ncode : int = bits(4) + 4; 
			if(nlen > MAXLCODES || ndist > MAXDCODES) throw new Error("Error", -3);
			for(var index : int = 0;index < ncode; index++) lengths[order[index]] = bits(3);
			for(;index < 19; index++) lengths[order[index]] = 0;
			var err : int = construct(lencode, lengths, 19);
			if(err != 0) throw new Error("Error", -4);
			index = 0;
			while(index < nlen + ndist) {
				var symbol : int; 
				var len : int;
				symbol = decode(lencode);
				if(symbol < 16) lengths[index++] = symbol; else {
					len = 0;
					if(symbol == 16) { 
						if(index == 0) throw new Error("Error", -5);
						len = lengths[index - 1]; 
						symbol = 3 + bits(2);
					}
					else if(symbol == 17) symbol = 3 + bits(3); 
					else symbol = 11 + bits(7); 
					if(index + symbol > nlen + ndist)
						throw new Error("Error", -6);
					while(symbol--) lengths[index++] = len; 
				}
			}
			err = construct(lencode, lengths, nlen);
			if(err < 0 || (err > 0 && nlen - lencode.count[0] != 1))
				throw new Error("Error", -7);
			err = construct(distcode, lengths.slice(nlen), ndist);
			if(err < 0 || (err > 0 && ndist - distcode.count[0] != 1))
				throw new Error("Error", -8);
			return err;
		}
	}
}
