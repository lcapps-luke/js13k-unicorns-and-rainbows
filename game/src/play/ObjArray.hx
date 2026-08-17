package play;

class ObjArray<T:AbstractObject>{
	private var inner:Array<T>;

	public function new(){
		inner = new Array<T>();
	}

	public function recycle(constructor:Void->T):T{
		for(o in inner){
			if(!o.alive){
				return o;
			}
		}
		var n = constructor();
		inner.push(n);
		return n;
	}

	public function update(s:Float){
		each(o -> o.update(s));
	}

	public function each(c:T -> Void){
		for(o in inner){
			if(o.alive){
				c(o);
			}
		}
	}
}